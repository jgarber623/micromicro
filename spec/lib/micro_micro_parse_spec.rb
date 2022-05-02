# frozen_string_literal: true

RSpec.describe MicroMicro, '.parse' do
  subject(:document) { described_class.parse(markup, base_url) }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<!doctype html><html><body><article class="h-entry"><h1 class="p-name">Hello, world!</h1></article></body></html>' }

  it 'returns a MicroMicro::Document' do
    expect(document).to be_a(MicroMicro::Document)
  end
end
