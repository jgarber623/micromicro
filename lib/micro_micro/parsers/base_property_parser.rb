module MicroMicro
  module Parsers
    class BasePropertyParser
      # @param node [Nokogiri::XML::Element]
      def initialize(node)
        @node = node
      end

      # @return [String]
      def value
        @value ||= serialized_node.text.strip
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

      attr_reader :node

      # @see microformats2 Parsing Specification sections 1.3.1 and 1.3.4
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_a_p-_property
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_an_e-_property
      def serialized_node
        @serialized_node ||= begin
          node.css(*Document.ignored_node_names).unlink

          node.css('img').each { |img| img.content = " #{img['alt'] || Absolutely.to_abs(base: node.document.url, relative: img['src'])} " }

          node
        end
      end
    end
  end
end
