require 'rails_helper'

RSpec.describe 'config/initializers/vips.rb' do
  it "turns off libvips' operation cache" do
    expect(Vips.cache_max).to eq(0)
  end

  it 'runs a full garbage collection after each image resize' do
    expect(GC).to receive(:start)

    ActiveStorage::TransformJob.new.run_callbacks(:perform) { :resized }
  end
end
