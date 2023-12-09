# frozen_string_literal: true

RSpec.describe MicroMicro::Collections::PropertiesCollection do
  subject(:collection) { MicroMicro.parse(markup, base_url).items.first.properties }

  let(:base_url) { "http://example.com" }

  let(:markup) do
    <<~HTML.chomp
      <article class="h-entry">
        <h1 class="p-name">
          <a href="https://jgarber.example/posts/hello-world" class="u-url">Hello, world!</a>
        </h1>
        <a href="https://jgarber.example" class="p-author h-card">Jason Garber</a>
      </article>
    HTML
  end

  its(:names) { is_expected.to eq(%w[author name url]) }

  its(:values) do
    is_expected.to eq(
      [
        "Hello, world!",
        "https://jgarber.example/posts/hello-world",
        { properties: { name: ["Jason Garber"], url: ["https://jgarber.example/"] }, type: ["h-card"], value: "Jason Garber" }
      ]
    )
  end

  its(:plain_text_properties) { is_expected.to be_a(described_class) }
  its("plain_text_properties.first.name") { is_expected.to eq("name") }

  its(:plain_text_properties?) { is_expected.to be(true) }

  its(:url_properties) { is_expected.to be_a(described_class) }
  its("url_properties.first.name") { is_expected.to eq("url") }

  its(:url_properties?) { is_expected.to be(true) }
end
