module MicroMicro
  module Parsers
    class BasePropertyParser
      # @param node [Nokogiri::XML::Element]
      # @param context [Nokogiri::XML::Element, nil]
      def initialize(node, context = nil)
        @node = node
        @context = context
      end

      # @return [String]
      def value
        @value ||= sanitized_node.text.strip
      end

      # @param node [Nokogiri::XML::Element]
      # @param attribute_map [Hash{String => Array<String}]
      # @return [Array<String>]
      def self.attribute_values_from(node, attribute_map)
        attribute_map.each_with_object([]) do |(attribute, elements), array|
          array << node[attribute] if elements.include?(node.name) && node[attribute]
        end
      end

      private

      attr_reader :context, :node

      def sanitized_node
        @sanitized_node ||= begin
          node.css(*Document.ignored_node_names).unlink

          node.css('img').each { |img| img.content = img['alt'] || Absolutely.to_abs(base: node.document.url, relative: img['src']) }

          node
        end
      end
    end
  end
end
