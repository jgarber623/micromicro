describe MicroMicro::Document, '#rels' do
  let(:relative_base) { 'https://relative.example.com' }
  let(:absolute_base) { 'https://absolute.example.com' }

  context 'when markup contains relative URLs' do
    let(:markup) { '<!doctype html><html><head><link rel="webmention" href="/webmentions"></head></html>' }

    let(:results) { OpenStruct.new(webmention: ["#{relative_base}/webmentions"]) }

    it 'returns an OpenStruct' do
      expect(described_class.new(markup, relative_base).rels).to eq(results)
    end
  end

  context 'when markup contains <base> element with relative URL' do
    let(:markup) { '<!doctype html><html><head><base href="/foo/bar"><link rel="webmention" href="webmentions"></head></html>' }

    let(:results) { OpenStruct.new(webmention: ["#{relative_base}/foo/webmentions"]) }

    it 'returns an OpenStruct' do
      expect(described_class.new(markup, relative_base).rels).to eq(results)
    end
  end

  context 'when markup contains <base> element with absolute URL' do
    let(:markup) { %(<!doctype html><html><head><base href="#{absolute_base}"><link rel="webmention" href="webmentions"></head></html>) }

    let(:results) { OpenStruct.new(webmention: ["#{absolute_base}/webmentions"]) }

    it 'returns an OpenStruct' do
      expect(described_class.new(markup, relative_base).rels).to eq(results)
    end
  end
end
