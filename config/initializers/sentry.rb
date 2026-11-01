# Sentry: error tracking, plus optional performance monitoring.
#
# SENTRY_DSN turns on error capture. Tracing is a separate, explicit opt-in
# (Sentry bills for ingested spans, so a DSN alone never sends any):
#
#   SENTRY_TRACING=sentry  Sentry's own tracing and StackProf profiling.
#                          Rates: SENTRY_TRACES_SAMPLE_RATE (default 0.1) and
#                          SENTRY_PROFILES_SAMPLE_RATE (default 1.0, a share of
#                          the sampled traces).
#   SENTRY_TRACING=otlp    Spree's OpenTelemetry spans (spree_opentelemetry:
#                          workflows, gateway calls, webhooks…) exported to
#                          Sentry over OTLP. Sample with OTEL_TRACES_SAMPLER /
#                          OTEL_TRACES_SAMPLER_ARG. No profiles in this mode:
#                          Sentry profiles attach to its own transactions.
#   unset / off            errors only (default).
#
# Use one tracer per process. With SENTRY_TRACING=sentry, don't also point
# OTEL_EXPORTER_OTLP_ENDPOINT at a collector, or every request is traced twice
# into two disconnected systems.
if ENV['SENTRY_DSN'].present?
  sentry_environments = %w[production staging]
  sentry_environments << 'development' if ENV['SENTRY_REPORT_ON_DEVELOPMENT'].present?

  sentry_tracing = ENV.fetch('SENTRY_TRACING', 'off').strip.downcase
  sentry_tracing = 'off' unless sentry_environments.include?(Rails.env)

  unless %w[off sentry otlp].include?(sentry_tracing)
    Rails.logger.warn "[Sentry] unknown SENTRY_TRACING=#{sentry_tracing.inspect} (expected sentry, otlp or off) — tracing disabled"
    sentry_tracing = 'off'
  end

  if sentry_tracing == 'otlp'
    if defined?(SpreeOpenTelemetry)
      # Sentry registers its OTLP exporter inside Sentry.init, which needs the
      # OpenTelemetry SDK installed first — so install it here instead of
      # waiting for spree_opentelemetry's own after-initializers hook.
      # Sentry provides the exporter (derived from the DSN); stop the SDK from
      # wiring its default OTLP exporter as well, unless one is set explicitly
      # (e.g. to also send traces to a collector).
      ENV['OTEL_TRACES_EXPORTER'] ||= 'none'
      SpreeOpenTelemetry.configure { |config| config.enabled = true }
      sentry_tracing = 'off' unless SpreeOpenTelemetry.install!
    else
      Rails.logger.warn '[Sentry] SENTRY_TRACING=otlp needs the spree_opentelemetry gem — tracing disabled'
      sentry_tracing = 'off'
    end
  elsif sentry_tracing == 'sentry' && defined?(SpreeOpenTelemetry) && SpreeOpenTelemetry.enabled?
    Rails.logger.warn '[Sentry] SENTRY_TRACING=sentry while OpenTelemetry is also exporting — requests will be traced twice. ' \
                      'Use SENTRY_TRACING=otlp to send the OpenTelemetry traces to Sentry instead.'
  end

  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.breadcrumbs_logger = %i[active_support_logger http_logger]
    config.enabled_environments = sentry_environments

    case sentry_tracing
    when 'sentry'
      config.traces_sample_rate = ENV.fetch('SENTRY_TRACES_SAMPLE_RATE', '0.1').to_f
      # Needs the stackprof gem, loaded before sentry-ruby (see Gemfile).
      config.profiles_sample_rate = ENV.fetch('SENTRY_PROFILES_SAMPLE_RATE', '1.0').to_f
    when 'otlp'
      # OpenTelemetry owns tracing: never set traces_sample_rate here.
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
