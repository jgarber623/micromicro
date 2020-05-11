module MicroMicro
  module Parsers
    class ImpliedNamePropertyParser < BasePropertyParser
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      HTML_ELEMENTS_MAP = {
        'area' => 'alt',
        'img'  => 'alt',
        'abbr' => 'title'
      }.freeze

      # @return [String]
      def value
        @value ||= begin
          return attribute_values.first if attribute_values.any?
          return child_node_attribute_values.first if parse_child_node? && child_node_attribute_values.any?
          return grandchild_node_attribute_values.first if parse_grandchild_node? && grandchild_node_attribute_values.any?

          Document.text_content_from(node) { |context| context.css('img').each { |img| img.content = img['alt'] } }
        end
      end

      private

      # @return [Array<String>]
      def attribute_values
        @attribute_values ||= begin
          HTML_ELEMENTS_MAP.map do |element, attribute|
            node[attribute] if node.matches?("#{element}[#{attribute}]")
          end.compact
        end
      end

      # @return [Nokogiri::XML::Element, nil]
      def child_node
        @child_node ||= node.at_css('> :only-child')
      end

      # @return [Array<String>]
      def child_node_attribute_values
        @child_node_attribute_values ||= begin
          HTML_ELEMENTS_MAP.map do |element, attribute|
            child_node[attribute] if child_node.matches?("#{element}[#{attribute}]")
          end.compact
        end
      end

      # @return [Nokogiri::XML::Element, nil]
      def grandchild_node
        @grandchild_node ||= child_node.at_css('> :only-child')
      end

      # @return [Array<String>]
      def grandchild_node_attribute_values
        @grandchild_node_attribute_values ||= begin
          HTML_ELEMENTS_MAP.map do |element, attribute|
            grandchild_node[attribute] if grandchild_node.matches?("#{element}[#{attribute}]")
          end.compact
        end
      end

      # @return [Boolean]
      def parse_child_node?
        child_node && !Item.item_node?(child_node)
      end

      # @return [Boolean]
      def parse_grandchild_node?
        parse_child_node? && grandchild_node && !Item.item_node?(grandchild_node)
      end
    end
  end
end
