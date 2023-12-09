# frozen_string_literal: true

RSpec.describe MicroMicro::Parsers::DateTimeParser do
  describe "#normalized_ordinal_date" do
    subject(:parser) { described_class.new("2022-174") }

    its(:normalized_ordinal_date) { is_expected.to eq("2022-174") }
  end

  describe "#values" do
    subject(:parser) { described_class.new("") }

    its(:values) { is_expected.to eq({}) }
  end
end
