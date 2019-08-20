describe MicroMicro, '.parse' do
  test_case_types = %w[rel]

  test_case_types.each do |test_case_type|
    context "when running the microformats-v2/#{test_case_type} test cases" do
      test_case_file_paths = Dir[File.join(FixturesHelpers::MicroformatsTestSuite.test_case_base_path, test_case_type, '*.json')]

      test_case_file_paths.each do |test_case_file_path|
        context "when parsing #{test_case_file_path.split('/').last}" do
          let(:test_case) { FixturesHelpers::MicroformatsTestSuite::TestCase.new(test_case_file_path) }

          it 'returns parsed JSON' do
            expect(described_class.parse(test_case.input)).to eq(test_case.output)
          end
        end
      end
    end
  end
end
