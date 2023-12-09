# frozen_string_literal: true

RSpec.describe MicroMicro::Collections::RelationshipsCollection do
  subject(:collection) { MicroMicro.parse(markup, base_url).relationships }

  let(:base_url) { "http://example.com" }

  let(:markup) { %(<a href="http://example.com/home" rel="home">Back home</a>) }

  its(:rels) { is_expected.to eq(["home"]) }

  its(:urls) { is_expected.to eq(["http://example.com/home"]) }
end
