describe MicroMicro::Document, '#rel_urls' do
  let(:relative_base) { 'https://relative.example.com' }
  let(:absolute_base) { 'https://absolute.example.com' }

  context 'when markup contains relative URLs' do
    let(:markup) { '<!doctype html><html><head><link rel="webmention" href="/webmentions"></head></html>' }

    let(:results) do
      OpenStruct.new("#{relative_base}/webmentions": OpenStruct.new(rels: ['webmention']))
    end

    it 'returns an OpenStruct' do
      expect(described_class.new(markup, relative_base).rel_urls).to eq(results)
    end
  end

  context 'when markup contains <base> element with relative URL' do
    let(:markup) { '<!doctype html><html><head><base href="/foo/bar"><link rel="webmention" href="webmentions"></head></html>' }

    let(:results) do
      OpenStruct.new("#{relative_base}/foo/webmentions": OpenStruct.new(rels: ['webmention']))
    end

    it 'returns an OpenStruct' do
      expect(described_class.new(markup, relative_base).rel_urls).to eq(results)
    end
  end

  context 'when markup contains <base> element with absolute URL' do
    let(:markup) { %(<!doctype html><html><head><base href="#{absolute_base}"><link rel="webmention" href="webmentions"></head></html>) }

    let(:results) do
      OpenStruct.new("#{absolute_base}/webmentions": OpenStruct.new(rels: ['webmention']))
    end

    it 'returns an OpenStruct' do
      expect(described_class.new(markup, relative_base).rel_urls).to eq(results)
    end
  end
end
