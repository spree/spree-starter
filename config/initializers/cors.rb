normalize_origin = lambda do |value|
  uri = URI.parse(value)
  return nil unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  return nil if uri.host.blank?

  "#{uri.scheme}://#{uri.host}"
rescue URI::InvalidURIError
  nil
end

allowed_origin_check = lambda do |source, _env|
  next false if source.blank? || source.bytesize > 253
  next false unless source.match?(%r{\Ahttps?://[^/\s]+\z})

  if Rails.env.development?
    normalized_source = normalize_origin.call(source)
    next false if normalized_source.nil?

    Rails.cache.fetch("cors/allowed_origin_host:#{normalized_source}", expires_in: 5.minutes) do
      Spree::AllowedOrigin.pluck(:origin).any? { |o| normalize_origin.call(o) == normalized_source }
    end
  else
    Rails.cache.fetch("cors/allowed_origin:#{source}", expires_in: 5.minutes) do
      Spree::AllowedOrigin.exists?(origin: source)
    end
  end
rescue StandardError => e
  Rails.logger.error("[CORS] Origin check failed for #{source.inspect}: #{e.message}")
  false
end

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins allowed_origin_check
    resource '/api/v3/admin/*', headers: :any,
                                methods: [:get, :post, :patch, :put, :delete, :options, :head],
                                credentials: true
  end
end
