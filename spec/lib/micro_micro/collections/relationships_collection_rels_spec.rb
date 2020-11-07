RSpec.describe MicroMicro::Collections::RelationshipsCollection, '#rels' do
  subject(:rels) { MicroMicro.parse(markup, base_url).relationships.rels }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<!doctype html><html><body><a href="http://example.com" rel="home">Back home</a></body></html>' }

  it 'returns an Array' do
    expect(rels).to eq(['home'])
  end
end
