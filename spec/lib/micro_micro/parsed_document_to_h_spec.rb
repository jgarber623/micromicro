describe MicroMicro::ParsedDocument, '#to_h' do
  let(:base_url) { 'https://example.com' }

  let(:empty_results_hash) do
    {
      items: [],
      rels: {},
      'rel-urls': {}
    }
  end

  context 'when markup is an empty String' do
    it 'returns an empty results Hash' do
      expect(described_class.new('', base_url).to_h).to eq(empty_results_hash)
    end
  end

  context 'when markup contains no microformats2-encoded data' do
    let(:markup) { '<!doctype html><html><body><h1>Hello, world!</h1></body></html>' }

    it 'returns an empty results Hash' do
      expect(described_class.new(markup, base_url).to_h).to eq(empty_results_hash)
    end
  end
end
