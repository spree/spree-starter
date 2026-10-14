require 'rails_helper'

RSpec.describe 'Root', type: :request do
  it 'redirects to the dashboard this app serves' do
    get '/'

    expect(response).to have_http_status(:found)
    expect(response).to redirect_to('http://www.example.com/dashboard')
  end

  context 'when the dashboard is hosted elsewhere' do
    before { Spree::Config.dashboard_url = 'https://admin.example.com' }

    it 'redirects to the configured dashboard URL' do
      get '/'

      expect(response).to redirect_to('https://admin.example.com')
    end
  end
end
