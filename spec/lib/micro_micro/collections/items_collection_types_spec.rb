RSpec.describe MicroMicro::Collections::ItemsCollection, '#types' do
  subject(:types) { MicroMicro.parse(markup, base_url).items.types }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<!doctype html><html><body><article class="h-entry"><h1 class="p-name">Hello, world!</h1></article></body></html>' }

  it 'returns an Array' do
    expect(types).to eq(['h-entry'])
  end
end
