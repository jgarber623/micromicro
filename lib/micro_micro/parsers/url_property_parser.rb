module MicroMicro
  module Parsers
    class UrlPropertyParser < BasePropertyParser
      # @see microformats2 Parsing Specification section 1.3.2
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_a_u-_property
      HTML_ATTRIBUTE_MAP = {
        'href'   => %w[a area link],
        'src'    => %w[audio img source video],
        'poster' => %w[video],
        'data'   => %w[object]
      }.freeze

      # @see microformats2 Parsing Specification section 1.3.2
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_a_u-_property
      EXTENDED_HTML_ATTRIBUTE_MAP = {
        'title' => %w[abbr],
        'value' => %w[data input]
      }.freeze

      # @return [String, Hash{Symbol => String}]
      def value
        @value ||= self.class.structured_value_from(node, resolved_value)
      end

      private

      # @return [MicroMicro::Parsers::AttributesParser]
      def attributes_parser
        @attributes_parser ||= AttributesParser.new(node_set, HTML_ATTRIBUTE_MAP)
      end

      # @return [MicroMicro::Parsers::AttributesParser]
      def extended_attributes_parser
        @extended_attributes_parser ||= AttributesParser.new(node_set, EXTENDED_HTML_ATTRIBUTE_MAP)
      end

      # @return [String]
      def resolved_value
        @resolved_value ||= Absolutely.to_abs(base: node.document.url, relative: unresolved_value.strip)
      end

      # @return [String]
      def unresolved_value
        @unresolved_value ||= begin
          return attributes_parser.values.first if attributes_parser.values?
          return value_class_pattern_parser.value if value_class_pattern_parser.value?
          return extended_attributes_parser.values.first if extended_attributes_parser.values?

          serialized_node.text
        end
      end

      # @return [MicroMicro::Parsers::ValueClassPatternParser]
      def value_class_pattern_parser
        @value_class_pattern_parser ||= ValueClassPatternParser.new(node)
      end
    end
  end
end
