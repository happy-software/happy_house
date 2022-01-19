# frozen_string_literal: true

# https://sentry.io/organizations/my-happy-house/projects/my-happy-house/getting-started/ruby-rails/
Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]
  config.breadcrumbs_logger = [:active_support_logger]

  config.traces_sample_rate = 0.5
end
