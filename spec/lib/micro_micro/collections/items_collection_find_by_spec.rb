# frozen_string_literal: true

RSpec.describe MicroMicro::Collections::ItemsCollection, "#find_by" do
  let(:base_url) { "https://jgarber.example" }

  let(:document) { MicroMicro.parse(markup, base_url) }

  let(:items) { document.items }

  let(:markup) do
    <<~HTML.chomp
      <article class="h-entry" id="post-1">
        <h1 class="p-name">
          <a href="https://jgarber.example/posts/hello-world" class="u-url">Hello, world!</a>
        </h1>
        <a href="https://jgarber.example" class="p-author h-card" id="card-1">Jason Garber</a>
      </article>
      <article class="h-entry" id="post-2">
        <h1 class="p-name">
          <a href="https://jgarber.example/posts/me-again" class="u-url">Me again!</a>
        </h1>
      </article>
    HTML
  end

  context "when given neither params nor a block" do
    subject(:item) { items.find_by }

    it { is_expected.to eq(item) }
  end

  context "when no match" do
    subject(:item) { items.find_by(types: ["h-event"]) }

    it { is_expected.to be_nil }
  end

  context "when given Hash params" do
    context "when value is a String" do
      subject(:item) { items.find_by(types: "h-card") }

      its(:id) { is_expected.to eq("card-1") }
    end

    context "when value is an Array" do
      subject(:item) { items.find_by(types: ["h-entry", "h-card"]) }

      its(:id) { is_expected.to eq("post-1") }
    end
  end

  context "when given a block" do
    subject(:item) { items.find_by { |item| item.id == "post-2" } }

    its(:id) { is_expected.to eq("post-2") }
  end
end
