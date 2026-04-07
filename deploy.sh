#!/bin/bash
# SkyLockr Community App - Deployment Script
# Usage: ./deploy.sh [environment]

set -e

ENVIRONMENT=${1:-production}
COMPOSE_FILE="docker-compose.yml"

echo "=================================="
echo "SkyLockr Community Deployment"
echo "Environment: $ENVIRONMENT"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed"
        exit 1
    fi
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose is not installed"
        exit 1
    fi
    
    # Check .env file
    if [ ! -f .env ]; then
        if [ -f .env.example ]; then
            log_warn ".env file not found, copying from .env.example"
            cp .env.example .env
            log_warn "Please edit .env with your configuration before continuing"
            exit 1
        else
            log_error ".env file not found and no .env.example available"
            exit 1
        fi
    fi
    
    log_info "Prerequisites check passed"
}

# Build images
build_images() {
    log_info "Building Docker images..."
    docker-compose -f $COMPOSE_FILE build --no-cache
    log_info "Images built successfully"
}

# Start services
start_services() {
    log_info "Starting services..."
    docker-compose -f $COMPOSE_FILE up -d
    
    # Wait for database
    log_info "Waiting for database to be ready..."
    until docker-compose exec -T postgres pg_isready -U skylockr; do
        sleep 2
    done
    
    # Wait for Redis
    log_info "Waiting for Redis to be ready..."
    until docker-compose exec -T redis redis-cli ping | grep -q PONG; do
        sleep 2
    done
    
    log_info "Services started successfully"
}

# Run database migrations
run_migrations() {
    log_info "Running database migrations..."
    docker-compose exec -T discourse bundle exec rake db:migrate
    log_info "Migrations completed"
}

# Seed database (first run only)
seed_database() {
    if [ "$SEED_DATABASE" = "true" ]; then
        log_info "Seeding database..."
        docker-compose exec -T discourse bundle exec rake db:seed_fu
        log_info "Database seeded"
    fi
}

# Precompile assets
precompile_assets() {
    log_info "Precompiling assets..."
    docker-compose exec -T discourse bundle exec rake assets:precompile
    log_info "Assets precompiled"
}

# Health check
health_check() {
    log_info "Running health checks..."
    
    # Check Discourse
    if curl -f -s http://localhost/health > /dev/null; then
        log_info "Discourse: OK"
    else
        log_error "Discourse: FAILED"
        return 1
    fi
    
    # Check Postgres
    if docker-compose exec -T postgres pg_isready -U skylockr > /dev/null 2>&1; then
        log_info "PostgreSQL: OK"
    else
        log_error "PostgreSQL: FAILED"
        return 1
    fi
    
    # Check Redis
    if docker-compose exec -T redis redis-cli ping | grep -q PONG; then
        log_info "Redis: OK"
    else
        log_error "Redis: FAILED"
        return 1
    fi
    
    log_info "All health checks passed"
}

# Show status
show_status() {
    echo ""
    echo "=================================="
    echo "Deployment Status"
    echo "=================================="
    docker-compose ps
    echo ""
    echo "Access your SkyLockr Community at:"
    echo "  - Web: https://community.skylockr.com (or your configured hostname)"
    echo "  - Grafana: http://localhost:3000"
    echo "  - Prometheus: http://localhost:9090"
    echo ""
}

# Main deployment flow
main() {
    check_prerequisites
    
    case $ENVIRONMENT in
        production)
            build_images
            start_services
            run_migrations
            seed_database
            precompile_assets
            health_check
            show_status
            log_info "Deployment completed successfully!"
            ;;
        development)
            log_info "Starting development environment..."
            docker-compose -f $COMPOSE_FILE up --build
            ;;
        stop)
            log_info "Stopping services..."
            docker-compose -f $COMPOSE_FILE down
            ;;
        restart)
            log_info "Restarting services..."
            docker-compose -f $COMPOSE_FILE restart
            health_check
            ;;
        logs)
            docker-compose -f $COMPOSE_FILE logs -f
            ;;
        *)
            echo "Usage: $0 [production|development|stop|restart|logs]"
            exit 1
            ;;
    esac
}

main
