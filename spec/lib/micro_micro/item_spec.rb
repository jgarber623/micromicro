# frozen_string_literal: true

RSpec.describe MicroMicro::Item do
  subject(:item) { MicroMicro.parse(markup, base_url).items.first }

  let(:base_url) { 'http://example.com' }

  let(:markup) { '<a href="http://example.com" class="h-card">Jason Garber</a>' }

  its(:plain_text_properties) { is_expected.to be_a(MicroMicro::Collections::PropertiesCollection) }
  its('plain_text_properties.first.name') { is_expected.to eq('name') }

  its(:plain_text_properties?) { is_expected.to be(true) }

  its(:url_properties) { is_expected.to be_a(MicroMicro::Collections::PropertiesCollection) }
  its('url_properties.first.name') { is_expected.to eq('url') }

  its(:url_properties?) { is_expected.to be(true) }
end
