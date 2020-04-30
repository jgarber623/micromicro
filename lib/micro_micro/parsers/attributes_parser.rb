module MicroMicro
  module Parsers
    class AttributesParser
      # @param node_set [Nokogiri::XML::NodeSet]
      # @param attribute_map [Hash{Symbol => Array<String>}]
      def initialize(node_set, attribute_map)
        @node_set = node_set
        @attribute_map = attribute_map
      end

      # @return [Array]
      def present_values
        @present_values ||= values.select(&:present?)
      end

      def present_values?
        present_values.any?
      end

      # @return [Array]
      def values
        @values ||= node_set.map { |node| values_from(node) }.flatten
      end

      # @return [Boolean]
      def values?
        values.any?
      end

      private

      attr_reader :attribute_map, :node_set

      # @param node [Nokogiri::XML::Element]
      # @return [Array]
      def values_from(node)
        attribute_map.each_with_object([]) do |(attribute, elements), array|
          array << node[attribute] if elements.include?(node.name) && node[attribute]
        end
      end
    end
  end
end
