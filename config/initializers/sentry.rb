# Sentry: error tracking, plus optional tracing through OpenTelemetry.
#
# SENTRY_DSN turns on error capture. SENTRY_TRACING=true additionally sends
# Spree's OpenTelemetry spans (spree_opentelemetry: requests, queries, jobs,
# workflows and their steps, gateway calls, webhook deliveries) to Sentry over
# OTLP. It is a separate opt-in because Sentry bills for ingested spans.
#
# Sentry's own tracer is never used: OpenTelemetry owns tracing, Sentry is the
# backend, and errors are linked to the span that was active when raised.
# Sample with the standard OpenTelemetry variables (the SDK default is 100%):
#
#   OTEL_TRACES_SAMPLER=parentbased_traceidratio
#   OTEL_TRACES_SAMPLER_ARG=0.1
if ENV['SENTRY_DSN'].present?
  sentry_environments = %w[production staging]
  sentry_environments << 'development' if ENV['SENTRY_REPORT_ON_DEVELOPMENT'].present?

  # The environment Sentry itself reports under (same precedence as sentry-ruby).
  sentry_environment = ENV['SENTRY_CURRENT_ENV'].presence || ENV['SENTRY_ENVIRONMENT'].presence || Rails.env
  sentry_tracing = ActiveModel::Type::Boolean.new.cast(ENV['SENTRY_TRACING'].presence) &&
    sentry_environments.include?(sentry_environment)

  if sentry_tracing
    # Sentry registers its OTLP exporter inside Sentry.init, which needs the
    # OpenTelemetry SDK installed first — so install it here instead of
    # waiting for spree_opentelemetry's own after-initializers hook.
    # Sentry provides the exporter (derived from the DSN). Unless an OTEL_*
    # exporter is already configured (e.g. to also send traces to a
    # collector), stop the SDK from wiring its default OTLP exporter too.
    ENV['OTEL_TRACES_EXPORTER'] ||= 'none' unless SpreeOpenTelemetry.enabled?
    SpreeOpenTelemetry.configure { |config| config.enabled = true }
    sentry_tracing = SpreeOpenTelemetry.install!
  end

  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
    # Same value the tracing gate above checked, so a blank SENTRY_*_ENV
    # can't leave errors filtered out while spans are still exported.
    config.environment = sentry_environment
    config.breadcrumbs_logger = %i[active_support_logger http_logger]
    config.enabled_environments = sentry_environments

    # Never set traces_sample_rate: that would start Sentry's own tracer
    # alongside OpenTelemetry and trace every request twice.
    if sentry_tracing
      config.otlp.enabled = true
      config.otlp.setup_otlp_traces_exporter = true
    end

    config.excluded_exceptions += [
      'ActionController::RoutingError',
      'ActiveRecord::RecordNotFound',
      'Aws::S3::Errors::NoSuchKey',
      'Aws::S3::Errors::NotFound',
      'ActiveStorage::FileNotFoundError'
    ]

    # Use native Rails error subscriber
    # https://guides.rubyonrails.org/error_reporting.html
    config.rails.register_error_subscriber = true
  end
end
