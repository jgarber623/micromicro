module MicroMicro
  module Parsers
    class PlainTextPropertyParser < BasePropertyParser
      # @see microformats2 Parsing Specification section 1.3.1
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_a_p-_property
      HTML_ATTRIBUTES_MAP = {
        'title' => %w[abbr link],
        'value' => %w[data input],
        'alt'   => %w[area img]
      }.freeze

      # @return [String]
      def value
        @value ||= begin
          return value_class_pattern_parser.value if value_class_pattern_parser.value?
          return attribute_values.first if attribute_values.any?

          super
        end
      end

      private

      # @return [Array<String>]
      def attribute_values
        @attribute_values ||= begin
          HTML_ATTRIBUTES_MAP.map do |attribute, names|
            node[attribute] if names.include?(node.name) && node[attribute]
          end.compact
        end
      end

      # @return [MicroMicro::Parsers::ValueClassPatternParser]
      def value_class_pattern_parser
        @value_class_pattern_parser ||= ValueClassPatternParser.new(node)
      end
    end
  end
end
