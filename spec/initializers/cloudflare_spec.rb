require 'rails_helper'

RSpec.describe CloudflareRangeRefresh do
  include ActiveSupport::Testing::TimeHelpers

  let(:importer) { CloudflareRails::Importer }
  let(:bundled) { CloudflareRails::FallbackIps::IPS_V4 + CloudflareRails::FallbackIps::IPS_V6 }
  let(:downloaded_v4) { [IPAddr.new('198.51.100.0/24')] }
  let(:downloaded_v6) { [IPAddr.new('2001:db8::/32')] }

  def forget_ranges
    %i[@ips @ranges @ranges_stale_at].each { |name| importer.instance_variable_set(name, nil) }
  end

  def downloads_succeed
    allow(importer).to receive(:fetch_with_cache).with(:ips_v4).and_return(downloaded_v4)
    allow(importer).to receive(:fetch_with_cache).with(:ips_v6).and_return(downloaded_v6)
  end

  def downloads_fail
    allow(importer).to receive(:fetch_with_cache).and_raise(SocketError, 'getaddrinfo failed')
  end

  before do
    allow(importer).to receive(:cloudflare_ips).and_call_original
    forget_ranges
  end

  after { forget_ranges }

  it 'downloads the ranges once and reuses them' do
    downloads_succeed

    3.times { expect(importer.cloudflare_ips).to eq(downloaded_v4 + downloaded_v6) }

    expect(importer).to have_received(:fetch_with_cache).with(:ips_v4).once
  end

  it 'refreshes a downloaded list after twelve hours' do
    downloads_succeed
    importer.cloudflare_ips

    travel_to(13.hours.from_now) { importer.cloudflare_ips }

    expect(importer).to have_received(:fetch_with_cache).with(:ips_v4).twice
  end

  it 'serves the bundled list while downloads fail, retrying only every five minutes' do
    downloads_fail

    3.times { expect(importer.cloudflare_ips).to eq(bundled) }
    expect(importer).to have_received(:fetch_with_cache).once

    travel_to(6.minutes.from_now) { importer.cloudflare_ips }
    expect(importer).to have_received(:fetch_with_cache).twice
  end

  it 'keeps the last downloaded list when a refresh fails' do
    downloads_succeed
    importer.cloudflare_ips
    downloads_fail

    travel_to(13.hours.from_now) do
      expect(importer.cloudflare_ips).to eq(downloaded_v4 + downloaded_v6)
    end
  end

  it 'picks up new ranges once downloads recover' do
    downloads_fail
    importer.cloudflare_ips
    downloads_succeed

    travel_to(6.minutes.from_now) do
      expect(importer.cloudflare_ips).to eq(downloaded_v4 + downloaded_v6)
    end
  end
end
