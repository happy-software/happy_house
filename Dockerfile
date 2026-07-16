# syntax=docker/dockerfile:1

# Production image for Dokku (Raspberry Pi arm64 or x86_64).
# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.10
FROM ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Update gems and bundler
RUN gem update --system --no-document && \
    gem install -N bundler


# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to compile native gems (pg, sassc, bcrypt, ...).
# libvips is needed at build time too: Rails 8.1's Active Storage engine does
# `require "ruby-vips"` while loading, and without libvips the LoadError leaves
# the engine half-initialized, crashing `load_defaults` during assets:precompile.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev pkg-config libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Final stage for app image
FROM base

# Install packages needed for deployment:
# - libpq5 + postgresql-client: Postgres driver and psql for `rails dbconsole`
# - libvips: Active Storage image variants (ruby-vips is require: false and
#   loads this on demand when ActionText renders an embedded image)
# - chromium + fonts-liberation: headless PDF rendering for ferrum_pdf (lease
#   PDFs); Debian ships chromium for both arm64 and amd64, so it works on the Pi
# - libjemalloc2: lower memory usage/fragmentation (worth it on a Pi)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libpq5 postgresql-client libvips libjemalloc2 chromium fonts-liberation && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Tell Ferrum where the browser lives (it honors BROWSER_PATH)
ENV BROWSER_PATH="/usr/bin/chromium"

# Flags headless Chrome needs inside a container, injected via Debian's
# /usr/bin/chromium wrapper (it sources /etc/chromium.d/* and ignores a
# CHROMIUM_FLAGS env var):
#   --no-sandbox            Chrome's kernel sandbox isn't available under
#                           Docker's default seccomp profile; we only render
#                           our own lease HTML, not untrusted pages
#   --disable-dev-shm-usage /dev/shm is only 64MB in Docker; use /tmp instead
RUN echo 'CHROMIUM_FLAGS="$CHROMIUM_FLAGS --no-sandbox --disable-gpu --disable-dev-shm-usage"' > /etc/chromium.d/container-flags

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p db log storage tmp/pids && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Deployment options
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true"

# Entrypoint enables jemalloc and prepares the database when starting the server
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Dokku reads EXPOSE to know which port to proxy to (puma defaults to 3000)
EXPOSE 3000

# Default command; Dokku's Procfile web/release entries override this
CMD ["./bin/rails", "server"]
