# frozen_string_literal: true

RSpec.describe MicroMicro::Collections::ItemsCollection, '#types' do
  subject(:types) { MicroMicro.parse(markup, base_url).items.types }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<html><body><article class="h-entry"><h1 class="p-name">Hello, world!</h1></article></body></html>' }

  it { is_expected.to eq(['h-entry']) }
end
