describe MicroMicro::Collections::RelationUrlsCollection, '#to_h' do
  let(:relative_base) { 'https://relative.example.com' }
  let(:absolute_base) { 'https://absolute.example.com' }

  let(:node_set) { Nokogiri::HTML(markup).css('[href][rel]') }

  context 'when markup contains relative URLs' do
    let(:markup) { '<!doctype html><html><head><link rel="webmention" href="/webmentions"></head></html>' }

    let(:results) do
      {
        "#{relative_base}/webmentions": {
          rels: ['webmention']
        }
      }
    end

    it 'returns a Hash' do
      expect(described_class.new(node_set, relative_base).to_h).to eq(results)
    end
  end

  context 'when markup contains <base> element with relative URL' do
    let(:markup) { '<!doctype html><html><head><base href="/foo/bar"><link rel="webmention" href="webmentions"></head></html>' }

    let(:results) do
      {
        "#{relative_base}/foo/webmentions": {
          rels: ['webmention']
        }
      }
    end

    it 'returns a Hash' do
      expect(described_class.new(node_set, "#{relative_base}/foo/bar").to_h).to eq(results)
    end
  end

  context 'when markup contains <base> element with absolute URL' do
    let(:markup) { %(<!doctype html><html><head><base href="#{absolute_base}"><link rel="webmention" href="webmentions"></head></html>) }

    let(:results) do
      {
        "#{absolute_base}/webmentions": {
          rels: ['webmention']
        }
      }
    end

    it 'returns a Hash' do
      expect(described_class.new(node_set, absolute_base).to_h).to eq(results)
    end
  end
end
