RSpec.describe MicroMicro::Collections::RelationshipsCollection, '#urls' do
  subject(:urls) { MicroMicro.parse(markup, base_url).relationships.urls }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<!doctype html><html><body><a href="http://example.com/home" rel="home">Back home</a></body></html>' }

  it 'returns an Array' do
    expect(urls).to eq(['http://example.com/home'])
  end
end
