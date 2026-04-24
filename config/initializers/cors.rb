Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ->(source, _env) {
      Rails.cache.fetch("cors/allowed_origin:#{source}", expires_in: 5.minutes) do
        Spree::AllowedOrigin.exists?(origin: source)
      end
    }
    resource '/api/v3/admin/*', headers: ['Content-Type', 'Authorization', 'Accept', 'X-Requested-With', 'X-Spree-Api-Key'],
                                methods: [:get, :post, :patch, :put, :delete, :options, :head],
                                credentials: true
  end
end
