# frozen_string_literal: true

RSpec.describe MicroMicro::Document, '#to_h' do
  let(:base_url) { 'http://example.com' }

  FixturesHelpers::MicroformatsTestSuite.test_case_file_paths.each do |test_case_file_path|
    context "when parsing #{test_case_file_path.match(%r{((?:[^/]+/){2}[^/]+)\.json$})[1]}.html" do
      subject(:document_hash) { described_class.new(test_case.input, base_url).to_h }

      let(:test_case) { FixturesHelpers::MicroformatsTestSuite::TestCase.new(test_case_file_path) }

      it { is_expected.to eq(test_case.output) }
    end
  end
end
