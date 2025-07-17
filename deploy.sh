#!/bin/bash

# Build and deployment script for the ER Data Monitoring System

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
ENVIRONMENT="development"
BUILD_IMAGE=true
PUSH_IMAGE=false
REGISTRY=""
TAG="latest"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Help function
show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Build and deploy the ER Data Monitoring System using Docker.

OPTIONS:
    -e, --environment    Environment to deploy (development, production) [default: development]
    -t, --tag           Docker image tag [default: latest]
    -r, --registry      Docker registry URL for pushing images
    -p, --push          Push built image to registry
    -h, --help          Show this help message

EXAMPLES:
    $0                                      # Build and run in development mode
    $0 -e production                        # Deploy in production mode
    $0 -e production -t v1.0.0 -r my-registry.com -p  # Build, tag, and push for production

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -t|--tag)
            TAG="$2"
            shift 2
            ;;
        -r|--registry)
            REGISTRY="$2"
            shift 2
            ;;
        -p|--push)
            PUSH_IMAGE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate environment
if [[ "$ENVIRONMENT" != "development" && "$ENVIRONMENT" != "production" ]]; then
    print_error "Environment must be either 'development' or 'production'"
    exit 1
fi

print_status "Starting deployment for environment: $ENVIRONMENT"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if docker compose is available (try both docker-compose and docker compose)
DOCKER_COMPOSE_CMD=""
if command -v docker-compose > /dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker-compose"
elif docker compose version > /dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    print_error "Docker Compose is not available. Please install Docker Compose and try again."
    exit 1
fi

print_status "Using Docker Compose command: $DOCKER_COMPOSE_CMD"

# Check if required files exist
if [[ ! -f "Dockerfile" ]]; then
    print_error "Dockerfile not found in current directory"
    exit 1
fi

if [[ ! -f "docker-compose.yml" ]]; then
    print_error "docker-compose.yml not found in current directory"
    exit 1
fi

# Create .env file if it doesn't exist
if [[ ! -f ".env" ]]; then
    print_warning ".env file not found, creating from .env.example"
    if [[ -f ".env.example" ]]; then
        cp .env.example .env
        print_status "Created .env file from .env.example"
        print_warning "Please review and update .env file with your configuration"
    else
        print_error ".env.example not found, cannot create .env file"
        exit 1
    fi
fi

# Build Docker image
if [[ "$BUILD_IMAGE" == true ]]; then
    IMAGE_NAME="erdata-monitoring-system"
    if [[ -n "$REGISTRY" ]]; then
        FULL_IMAGE_NAME="$REGISTRY/$IMAGE_NAME:$TAG"
    else
        FULL_IMAGE_NAME="$IMAGE_NAME:$TAG"
    fi
    
    print_status "Building Docker image: $FULL_IMAGE_NAME"
    docker build -t "$FULL_IMAGE_NAME" .
    
    if [[ $? -eq 0 ]]; then
        print_status "Docker image built successfully"
    else
        print_error "Failed to build Docker image"
        exit 1
    fi
    
    # Push image if requested
    if [[ "$PUSH_IMAGE" == true ]]; then
        if [[ -z "$REGISTRY" ]]; then
            print_error "Registry URL is required for pushing images"
            exit 1
        fi
        
        print_status "Pushing image to registry: $FULL_IMAGE_NAME"
        docker push "$FULL_IMAGE_NAME"
        
        if [[ $? -eq 0 ]]; then
            print_status "Image pushed successfully"
        else
            print_error "Failed to push image"
            exit 1
        fi
    fi
fi

# Deploy based on environment
case $ENVIRONMENT in
    development)
        print_status "Deploying in development mode"
        $DOCKER_COMPOSE_CMD -f docker-compose.yml -f docker-compose.dev.yml up -d
        ;;
    production)
        print_status "Deploying in production mode"
        if [[ -f "docker-compose.prod.yml" ]]; then
            $DOCKER_COMPOSE_CMD -f docker-compose.yml -f docker-compose.prod.yml --profile database --profile cache up -d
        else
            $DOCKER_COMPOSE_CMD --profile database --profile cache up -d
        fi
        ;;
esac

# Check deployment status
if [[ $? -eq 0 ]]; then
    print_status "Deployment completed successfully"
    
    # Show running containers
    print_status "Running containers:"
    $DOCKER_COMPOSE_CMD ps
    
    # Show access information
    N8N_PORT=$(grep N8N_PORT .env | cut -d '=' -f2 | head -1)
    N8N_PORT=${N8N_PORT:-5678}
    
    print_status ""
    print_status "==================================="
    print_status "ER Data Monitoring System is ready!"
    print_status "==================================="
    print_status "Access the system at: http://localhost:$N8N_PORT"
    print_status "Default credentials: admin/admin (change in .env file)"
    print_status ""
    print_status "To view logs: $DOCKER_COMPOSE_CMD logs -f"
    print_status "To stop: $DOCKER_COMPOSE_CMD down"
    print_status "==================================="
else
    print_error "Deployment failed"
    exit 1
fi