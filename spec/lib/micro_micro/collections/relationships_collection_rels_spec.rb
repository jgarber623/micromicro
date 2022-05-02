# frozen_string_literal: true

RSpec.describe MicroMicro::Collections::RelationshipsCollection, '#rels' do
  subject(:rels) { MicroMicro.parse(markup, base_url).relationships.rels }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<html><body><a href="http://example.com" rel="home">Back home</a></body></html>' }

  it { is_expected.to eq(['home']) }
end
