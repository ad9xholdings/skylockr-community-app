#!/bin/bash
# SkyLockr Discourse Entrypoint Script

set -e

# Environment setup
export RAILS_ENV=${RAILS_ENV:-production}
export UNICORN_WORKERS=${UNICORN_WORKERS:-4}
export UNICORN_SIDEKIQS=${UNICORN_SIDEKIQS:-2}
export DISCOURSE_HOSTNAME=${DISCOURSE_HOSTNAME:-community.skylockr.com}

# Wait for database
until pg_isready -h ${DISCOURSE_DB_HOST:-postgres} -p ${DISCOURSE_DB_PORT:-5432} -U ${DISCOURSE_DB_USER:-skylockr}; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

# Wait for Redis
until redis-cli -h ${DISCOURSE_REDIS_HOST:-redis} -p ${DISCOURSE_REDIS_PORT:-6379} ping | grep -q PONG; do
  echo "Waiting for Redis..."
  sleep 2
done

# Run database migrations
echo "Running database migrations..."
bundle exec rake db:migrate

# Seed database if needed
if [ "$SEED_DATABASE" = "true" ]; then
  echo "Seeding database..."
  bundle exec rake db:seed_fu
fi

# Precompile assets if in production
if [ "$RAILS_ENV" = "production" ]; then
  echo "Ensuring assets are precompiled..."
  bundle exec rake assets:precompile
fi

# Execute command
exec "$@"
