# frozen_string_literal: true

RSpec.describe MicroMicro::Collections::RelationshipsCollection, "#find_by" do
  let(:base_url) { "https://jgarber.example" }

  let(:document) { MicroMicro.parse(markup, base_url) }

  let(:relationships) { document.relationships }

  let(:markup) do
    <<~HTML.chomp
      <link href="https://jgarber.example/webmention" rel="webmention" >
      <a href="https://jgarber.example/home" rel="home">Back home</a>
      <a href="https://jgarber.example" class="h-card" rel="me">Jason Garber</a>
    HTML
  end

  context "when given neither params nor a block" do
    subject(:relationship) { relationships.find_by }

    it { is_expected.to eq(relationship) }
  end

  context "when no match" do
    subject(:relationship) { relationships.find_by(rels: ["foo"]) }

    it { is_expected.to be_nil }
  end

  context "when given Hash params" do
    context "when value is a String" do
      subject(:relationship) { relationships.find_by(rels: "home") }

      its(:rels) { is_expected.to eq(["home"]) }
    end

    context "when value is an Array" do
      subject(:relationship) { relationships.find_by(rels: %w[me webmention]) }

      its(:rels) { is_expected.to eq(["webmention"]) }
    end
  end

  context "when given a block" do
    subject(:relationship) { relationships.find_by { |rel| rel.text.match?(/\sGarber\Z/) } }

    its(:rels) { is_expected.to eq(["me"]) }
  end
end
