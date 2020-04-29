module MicroMicro
  module Parsers
    class DateTimePropertyParser < BasePropertyParser
      # @see microformats2 Parsing Specification section 1.3.3
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_a_dt-_property
      HTML_ATTRIBUTE_MAP = {
        'datetime' => %w[del ins time],
        'title'    => %w[abbr],
        'value'    => %w[data input]
      }.freeze

      def value
        @value ||= begin
          return date_time_parser.value if value_class_pattern_parser.value?
          return attribute_values.first.strip if attribute_values.any?

          super
        end
      end

      private

      def attribute_values
        @attribute_values ||= self.class.attribute_values_from(node, HTML_ATTRIBUTE_MAP)
      end

      def date_time_parser
        @date_time_parser ||= DateTimeParser.new(value_class_pattern_parser.value)
      end

      def value_class_pattern_parser
        @value_class_pattern_parser ||= ValueClassPatternParser.new(node, ' ')
      end
    end
  end
end
