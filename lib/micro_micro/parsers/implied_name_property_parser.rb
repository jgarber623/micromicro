module MicroMicro
  module Parsers
    class ImpliedNamePropertyParser < BasePropertyParser
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      HTML_ATTRIBUTES_MAP = {
        'alt'   => %w[area img],
        'title' => %w[abbr]
      }.freeze

      # @return [String]
      def value
        @value ||= attribute_value || child_node_attribute_value || grandchild_node_attribute_value || text_content
      end

      private

      # @return [String, nil]
      def attribute_value
        @attribute_value ||= self.class.attribute_value_from(node, HTML_ATTRIBUTES_MAP)
      end

      # @return [Nokogiri::XML::Element, nil]
      def child_node
        @child_node ||= node.at_css('> :only-child')
      end

      # @return [String, nil]
      def child_node_attribute_value
        @child_node_attribute_value ||= self.class.attribute_value_from(child_node, HTML_ATTRIBUTES_MAP) if parse_child_node?
      end

      # @return [Nokogiri::XML::Element, nil]
      def grandchild_node
        @grandchild_node ||= child_node.at_css('> :only-child')
      end

      # @return [String, nil]
      def grandchild_node_attribute_value
        @grandchild_node_attribute_value ||= self.class.attribute_value_from(grandchild_node, HTML_ATTRIBUTES_MAP) if parse_grandchild_node?
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
      def text_content
        @text_content ||= Document.text_content_from(node) { |context| context.css('img').each { |img| img.content = img['alt'] } }
      end
    end
  end
end
