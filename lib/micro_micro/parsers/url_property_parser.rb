module MicroMicro
  module Parsers
    class UrlPropertyParser < BasePropertyParser
      # @see microformats2 Parsing Specification section 1.3.2
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_a_u-_property
      PRIMARY_HTML_ATTRIBUTE_MAP = {
        'href'   => %w[a area link],
        'src'    => %w[audio img source video],
        'poster' => %w[video],
        'data'   => %w[object]
      }.freeze

      # @see microformats2 Parsing Specification section 1.3.2
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_a_u-_property
      SECONDARY_HTML_ATTRIBUTE_MAP = {
        'title' => %w[abbr],
        'value' => %w[data input]
      }.freeze

      # @return [String, Hash{Symbol => String}]
      def value
        @value ||= begin
          return resolved_value unless node.name == 'img' && node['alt']

          {
            value: resolved_value,
            alt: node['alt'].strip
          }
        end
      end

      private

      # @return [Array]
      def primary_attribute_values
        @primary_attribute_values ||= self.class.attribute_values_from(node, PRIMARY_HTML_ATTRIBUTE_MAP)
      end

      # @return [Array]
      def secondary_attribute_values
        @secondary_attribute_values ||= self.class.attribute_values_from(node, SECONDARY_HTML_ATTRIBUTE_MAP)
      end

      # @return [String]
      def resolved_value
        @resolved_value ||= Absolutely.to_abs(base: node.document.url, relative: unresolved_value)
      end

      # @return [String]
      def unresolved_value
        @unresolved_value ||= begin
          return primary_attribute_values.first.strip if primary_attribute_values.any?
          return value_class_pattern_parser.value if value_class_pattern_parser.value?
          return secondary_attribute_values.first.strip if secondary_attribute_values.any?

          sanitized_node.text.strip
        end
      end

      def value_class_pattern_parser
        @value_class_pattern_parser ||= ValueClassPatternParser.new(node)
      end
    end
  end
end
