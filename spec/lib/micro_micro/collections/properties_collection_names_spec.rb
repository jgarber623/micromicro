# frozen_string_literal: true

RSpec.describe MicroMicro::Collections::PropertiesCollection, '#names' do
  subject(:names) { MicroMicro.parse(markup, base_url).items.first.properties.names }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<html><body><article class="h-entry"><h1 class="p-name">Hello, world!</h1></article></body></html>' }

  it { is_expected.to eq(['name']) }
end
