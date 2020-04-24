module MicroMicro
  module Parsers
    class UrlPropertyParser < BasePropertyParser
      # @see microformats2 Parsing Specification section 1.3.2
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_a_u-_property
      HTML_ATTRIBUTE_MAP = {
        'href'   => %w[a area link],
        'src'    => %w[audio img source video],
        'poster' => %w[video],
        'data'   => %w[object],
        'title'  => %w[abbr],
        'value'  => %w[data input]
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

      # @return [String]
      def resolved_value
        @resolved_value ||= Absolutely.to_abs(base: node.document.url, relative: unresolved_value)
      end

      # @return [String]
      def unresolved_value
        @unresolved_value ||= begin
          HTML_ATTRIBUTE_MAP.slice('href', 'src', 'poster', 'data').each do |attribute, elements|
            return node[attribute].strip if elements.include?(node.name) && node[attribute]
          end

          return value_class_pattern_parser.value if value_class_pattern_parser.value?

          HTML_ATTRIBUTE_MAP.slice('title', 'value').each do |attribute, elements|
            return node[attribute].strip if elements.include?(node.name) && node[attribute]
          end

          sanitized_node.text.strip
        end
      end

      def value_class_pattern_parser
        @value_class_pattern_parser ||= ValueClassPatternParser.new(node)
      end
    end
  end
end
