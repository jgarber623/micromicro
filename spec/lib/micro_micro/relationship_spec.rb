# frozen_string_literal: true

RSpec.describe MicroMicro::Relationship do
  subject(:relationship) { MicroMicro.parse(markup, base_url).relationships.first }

  let(:base_url) { "http://example.com" }

  let(:markup) { %(<link rel="icon" href="https://sixtwothree.org/jgarber.png" type="image/png">) }

  its(:type) { is_expected.to eq("image/png") }
end
