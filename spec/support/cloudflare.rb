# cloudflare-rails downloads Cloudflare's published IP ranges on the first
# request. Specs use the list bundled with the gem instead, so the suite
# never depends on the network.
RSpec.configure do |config|
  config.before do
    allow(CloudflareRails::Importer).to receive(:cloudflare_ips).
      and_return(CloudflareRails::FallbackIps::IPS_V4 + CloudflareRails::FallbackIps::IPS_V6)
  end
end
