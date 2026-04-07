# SkyLockr Discourse Dockerfile
# Custom Discourse build with SkyLockr branding and XRP Wallet integration

FROM discourse/base:3.2.0

LABEL maintainer="SkyLockr Team <dev@skylockr.com>"
LABEL description="SkyLockr Community - Discourse with XRP Ledger Integration"

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libyaml-dev \
    libffi-dev \
    libreadline-dev \
    libgmp-dev \
    libncurses5-dev \
    libgdbm-dev \
    libdb-dev \
    tk-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/discourse

# Clone Discourse source
RUN git clone --depth 1 --branch v3.2.0 https://github.com/discourse/discourse.git /var/www/discourse

# Copy SkyLockr theme and plugins
COPY ./theme /var/www/discourse/plugins/skylockr-theme
COPY ./wallet-integration/discourse-plugin /var/www/discourse/plugins/xrp-wallet

# Install Ruby dependencies
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Install Node.js dependencies and build assets
RUN yarn install --frozen-lockfile && \
    yarn ember build --environment=production

# Precompile assets
RUN bundle exec rake assets:precompile

# Set up directories
RUN mkdir -p tmp/pids tmp/cache tmp/sockets log public/uploads && \
    chown -R discourse:discourse /var/www/discourse

# Copy custom entrypoint
COPY ./discourse/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:80/health || exit 1

# Expose port
EXPOSE 80

# Set user
USER discourse

# Entry point
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bundle", "exec", "unicorn", "-c", "config/unicorn.conf.rb"]
