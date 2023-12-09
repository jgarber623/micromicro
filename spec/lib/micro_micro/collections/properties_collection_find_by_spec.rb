# frozen_string_literal: true

RSpec.describe MicroMicro::Collections::PropertiesCollection, "#find_by" do
  let(:base_url) { "https://jgarber.example" }

  let(:document) { MicroMicro.parse(markup, base_url) }

  let(:properties) { document.items.first.properties }

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

  context "when given neither params nor a block" do
    subject(:property) { properties.find_by }

    it { is_expected.to eq(property) }
  end

  context "when no match" do
    subject(:property) { properties.find_by(name: ["foo"]) }

    it { is_expected.to be_nil }
  end

  context "when given Hash params" do
    context "when value is a String" do
      subject(:property) { properties.find_by(name: "url") }

      its(:value) { is_expected.to eq("https://jgarber.example/posts/hello-world") }
    end

    context "when value is an Array" do
      subject(:property) { properties.find_by(name: %w[author name]) }

      its(:value) { is_expected.to eq("Hello, world!") }
    end
  end

  context "when given a block" do
    subject(:property) { properties.find_by { |property| property.value.is_a?(Hash) } }

    let(:matched_value) do
      {
        properties: {
          name: ["Jason Garber"],
          url: ["https://jgarber.example/"]
        },
        type: ["h-card"],
        value: "Jason Garber"
      }
    end

    its(:value) { is_expected.to eq(matched_value) }
  end
end
