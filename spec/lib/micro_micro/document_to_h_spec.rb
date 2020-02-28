describe MicroMicro::Document, '#to_h' do
  subject(:document) { described_class.new(markup, base_url) }

  let(:base_url) { 'https://example.com' }

  let(:empty_results_hash) do
    {
      items: [],
      rels: {},
      'rel-urls': {}
    }
  end

  context 'when markup is an empty String' do
    let(:markup) { '' }

    it 'returns an empty results Hash' do
      expect(document.to_h).to eq(empty_results_hash)
    end
  end

  context 'when markup contains no microformats2-encoded data' do
    let(:markup) { '<!doctype html><html><body><h1>Hello, world!</h1></body></html>' }

    it 'returns an empty results Hash' do
      expect(document.to_h).to eq(empty_results_hash)
    end
  end
end
