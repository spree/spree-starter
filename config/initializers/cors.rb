Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins lambda do |source, _env|
      next false if source.blank? || source.bytesize > 253
      next false unless source.match?(%r{\Ahttps?://[^/\s]+\z})

      Rails.cache.fetch("cors/allowed_origin:#{source}", expires_in: 5.minutes) do
        Spree::AllowedOrigin.exists?(origin: source)
      end
    rescue StandardError => e
      Rails.logger.error("[CORS] Origin check failed for #{source.inspect}: #{e.message}")
      false
    end
    resource '/api/v3/admin/*', headers: ['Content-Type', 'Authorization', 'Accept', 'X-Requested-With', 'X-Spree-Api-Key'],
                                methods: [:get, :post, :patch, :put, :delete, :options, :head],
                                credentials: true
  end
end
