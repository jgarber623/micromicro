module FixturesHelpers
  module MicroformatsTestSuite
    def self.test_case_base_path
      File.expand_path('../../spec/support/fixtures/microformats_test_suite/tests/microformats-v2', __dir__)
    end

    class TestCase
      def initialize(output_file_path)
        @input_file_path = output_file_path.sub(/\.json$/, '.html')
        @output_file_path = output_file_path
      end

      def input
        @input ||= IO.read(input_file_path)
      end

      def output
        @output ||= JSON.parse(IO.read(output_file_path), symbolize_names: true)
      end

      private

      attr_reader :input_file_path, :output_file_path
    end
  end
end
