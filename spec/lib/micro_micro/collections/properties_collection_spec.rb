# frozen_string_literal: true

RSpec.describe MicroMicro::Collections::PropertiesCollection do
  subject(:collection) { MicroMicro.parse(markup, base_url).items.first.properties }

  let(:base_url) { 'http://example.com' }

  let(:markup) do
    <<~'HTML'.chomp
      <article class="h-entry">
        <h1 class="p-name">Hello, world!</h1>
        <a href="http://example.com" class="p-author h-card">Jason Garber</a>
      </article>
    HTML
  end

  its(:names) { is_expected.to eq(%w[author name]) }

  its(:values) { is_expected.to eq(['Hello, world!', { properties: { name: ['Jason Garber'], url: ['http://example.com/'] }, type: ['h-card'], value: 'Jason Garber' }]) }
end
