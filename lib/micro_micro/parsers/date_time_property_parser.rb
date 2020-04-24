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

      # TODO: return proper dates according to the spec
      def value
        @value ||= begin
          return value_class_pattern_parser.value if value_class_pattern_parser.value?

          HTML_ATTRIBUTE_MAP.each do |attribute, elements|
            return node[attribute].strip if elements.include?(node.name) && node[attribute]
          end

          super
        end
      end

      private

      def value_class_pattern_parser
        @value_class_pattern_parser ||= ValueClassPatternParser.new(node, ' ')
      end
    end
  end
end
