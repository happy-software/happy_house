# frozen_string_literal: true

# https://sentry.io/organizations/my-happy-house/projects/my-happy-house/getting-started/ruby-rails/
# Skipped in test: sentry-rails 5.7's middleware breaks exception propagation
# under Rails 7.1 (request.show_exceptions? was removed), masking real errors.
unless Rails.env.test?
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.breadcrumbs_logger = [:active_support_logger]

    config.traces_sample_rate = 0.5
  end
end
