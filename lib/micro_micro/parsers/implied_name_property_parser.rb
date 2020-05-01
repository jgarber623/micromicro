module MicroMicro
  module Parsers
    class ImpliedNamePropertyParser < BasePropertyParser
      # @see microformats2 Parsing Specification section 1.3.5
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      HTML_ELEMENTS_MAP = {
        'area' => 'alt',
        'img'  => 'alt',
        'abbr' => 'title'
      }.freeze

      # @return [String]
      def value
        @value ||= unresolved_value.strip
      end

      private

      # @return [Nokogiri::XML::Element, nil]
      def child_node
        @child_node ||= node.at_css('> :only-child')
      end

      # @return [Nokogiri::XML::Element, nil]
      def grandchild_node
        @grandchild_node ||= child_node.at_css('> :only-child')
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
        HTML_ELEMENTS_MAP.each do |element, attribute|
          return node[attribute] if node.matches?("#{element}[#{attribute}]")
        end

        if parse_child_node?
          HTML_ELEMENTS_MAP.each do |element, attribute|
            return child_node[attribute] if child_node.matches?("#{element}[#{attribute}]")
          end
        end

        if parse_grandchild_node?
          HTML_ELEMENTS_MAP.each do |element, attribute|
            return grandchild_node[attribute] if grandchild_node.matches?("#{element}[#{attribute}]")
          end
        end

        serialized_node.css('img').each { |img| img.content = img['alt'] }

        serialized_node.text
      end
    end
  end
end
