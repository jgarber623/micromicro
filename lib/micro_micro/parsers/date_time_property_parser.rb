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
          return attributes_parser.values.first.strip if attributes_parser.values?

          super
        end
      end

      private

      # @return [MicroMicro::Parsers::AttributesParser]
      def attributes_parser
        @attributes_parser ||= AttributesParser.new(node_set, HTML_ATTRIBUTE_MAP)
      end

      # @return [MicroMicro::Parsers::DateTimeParser]
      def date_time_parser
        @date_time_parser ||= DateTimeParser.new(value_class_pattern_parser.value)
      end

      # @return [MicroMicro::Parsers::ValueClassPatternParser]
      def value_class_pattern_parser
        @value_class_pattern_parser ||= ValueClassPatternParser.new(node, ' ')
      end
    end
  end
end
