module MicroMicro
  module Parsers
    class ImpliedNamePropertyParser < BasePropertyParser
      # @see microformats2 Parsing Specification section 1.3.5
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      HTML_ATTRIBUTE_MAP = {
        'alt'   => %w[area img],
        'title' => %w[abbr]
      }.freeze

      # @param node [Nokogiri::XML::Element]
      def initialize(node)
        super

        node_set << child_node if parse_child_node?
        node_set << grandchild_node if parse_grandchild_node?
      end

      # @return [String]
      def value
        @value ||= unresolved_value.strip
      end

      private

      # @return [MicroMicro::Parsers::AttributesParser]
      def attributes_parser
        @attributes_parser ||= AttributesParser.new(node_set, HTML_ATTRIBUTE_MAP)
      end

      # @return [Nokogiri::XML::Element, nil]
      def child_node
        @child_node ||= node.first_element_child if node.element_children.one?
      end

      # @return [Nokogiri::XML::Element, nil]
      def grandchild_node
        @grandchild_node ||= child_node.first_element_child if child_node.element_children.one?
      end

      # @return [Boolean]
      def parse_child_node?
        child_node && !Item.item_node?(child_node)
      end

      # @return [Boolean]
      def parse_grandchild_node?
        parse_child_node? && grandchild_node && !Item.item_node?(grandchild_node)
      end

      # @return [String]
      def unresolved_value
        return attributes_parser.present_values.first if attributes_parser.present_values?

        serialized_node.css('img').each { |img| img.content = img['alt'] }

        serialized_node.text
      end
    end
  end
end
