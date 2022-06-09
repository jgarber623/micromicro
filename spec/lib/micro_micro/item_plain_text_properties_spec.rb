# frozen_string_literal: true

RSpec.describe MicroMicro::Item, '#plain_text_properties' do
  subject(:plain_text_properties) { MicroMicro.parse(markup, base_url).items.first.plain_text_properties }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<html><body><a href="http://example.com" class="h-card">Jason Garber</a></body></html>' }

  it { is_expected.to be_a(MicroMicro::Collections::PropertiesCollection) }
  its('first.name') { is_expected.to eq('name') }
end
