#!/bin/bash
# PostgreSQL initialization script for SkyLockr Community

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Enable required extensions
    CREATE EXTENSION IF NOT EXISTS hstore;
    CREATE EXTENSION IF NOT EXISTS pg_trgm;
    CREATE EXTENSION IF NOT EXISTS unaccent;
    
    -- Create discourse user if not exists
    DO \$\$
    BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'discourse') THEN
            CREATE USER discourse WITH PASSWORD '${POSTGRES_PASSWORD}';
        END IF;
    END
    \$\$;
    
    -- Grant privileges
    GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO discourse;
    
    -- Optimize for Discourse
    ALTER SYSTEM SET shared_buffers = '256MB';
    ALTER SYSTEM SET effective_cache_size = '768MB';
    ALTER SYSTEM SET maintenance_work_mem = '64MB';
    ALTER SYSTEM SET work_mem = '5242kB';
    
EOSQL

echo "PostgreSQL initialized for SkyLockr Community"
