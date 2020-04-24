module FixturesHelpers
  module MicroformatsTestSuite
    class << self
      def test_case_base_path
        File.expand_path('fixtures/microformats_test_suite/tests', __dir__)
      end

      def test_case_file_paths
        test_case_types.map { |test_case_type| Dir[File.join(test_case_base_path, test_case_type, '*.json')] }.flatten
      end

      def test_case_types
        %w[
          microformats-v2/h-adr
          microformats-v2/h-card
          microformats-v2/h-entry
          microformats-v2/h-event
          microformats-v2/h-feed
          microformats-v2/h-geo
          microformats-v2/h-product
          microformats-v2/h-recipe
          microformats-v2/h-resume
          microformats-v2/h-review
          microformats-v2/h-review-aggregate
          microformats-v2/mixed
        ]
      end
    end

    class TestCase
      def initialize(output_file_path)
        @input_file_path = output_file_path.sub('.json', '.html')
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
