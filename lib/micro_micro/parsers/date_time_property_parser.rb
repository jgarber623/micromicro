module MicroMicro
  module Parsers
    class DateTimePropertyParser < BasePropertyParser
      # @see microformats2 Parsing Specification section 1.3.3
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_a_dt-_property
      HTML_ATTRIBUTES_MAP = {
        'datetime' => %w[del ins time],
        'title'    => %w[abbr],
        'value'    => %w[data input]
      }.freeze

      # @return [String]
      def value
        @value ||= begin
          return date_time_parser.value if value_class_pattern_parser.value?

          HTML_ATTRIBUTES_MAP.each do |attribute, names|
            return node[attribute] if names.include?(node.name) && node[attribute]
          end

          super
        end
      end

      private

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
