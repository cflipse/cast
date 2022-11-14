if Rails.application.credentials.sentry_dsn
  Sentry.init do |config|
    config.dsn = Rails.application.credentials.sentry_dsn
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    config.environment = Rails.env

    # Set tracesSampleRate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production
    config.traces_sample_rate = 0.0005

    config.excluded_exceptions += %w[
      ActionController::RoutingError
      ActiveRecord::RecordNotFound
      Redis::ConnectionError
    ]
  end
end
