require 'rails_helper'

# Behind Cloudflare the last hop in X-Forwarded-For is a Cloudflare edge
# server, and a different one from request to request. cloudflare-rails trusts
# those ranges as proxies, so Spree's per-IP rate limits count the visitor.
RSpec.describe 'Client IP behind Cloudflare', type: :request do
  let(:login_params) { { email: 'visitor@example.com', password: 'Sup3rSecret!' } }

  # The test env's NullStore never counts; watching increment shows which
  # address each rate limit was charged to.
  before { allow(Rails.cache).to receive(:increment).and_return(1) }

  it 'charges rate limits to the visitor, not the Cloudflare edge server that relayed the request' do
    post '/api/v3/admin/auth/login', params: login_params,
                                     headers: { 'X-Forwarded-For' => '203.0.113.7, 172.70.1.1' }

    expect(Rails.cache).to have_received(:increment).with(a_string_ending_with(':203.0.113.7'), any_args).at_least(:once)
    expect(Rails.cache).not_to have_received(:increment).with(a_string_ending_with(':172.70.1.1'), any_args)
  end

  it 'ignores a forwarded address the visitor made up' do
    post '/api/v3/admin/auth/login', params: login_params,
                                     headers: { 'X-Forwarded-For' => '203.0.113.7, 198.51.100.9, 172.70.1.1' }

    expect(Rails.cache).to have_received(:increment).with(a_string_ending_with(':198.51.100.9'), any_args).at_least(:once)
    expect(Rails.cache).not_to have_received(:increment).with(a_string_ending_with(':203.0.113.7'), any_args)
  end
end
