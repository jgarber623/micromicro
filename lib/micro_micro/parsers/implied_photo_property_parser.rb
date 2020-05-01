module MicroMicro
  module Parsers
    class ImpliedPhotoPropertyParser < BasePropertyParser
      # @see microformats2 Parsing Specification section 1.3.5
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      HTML_ELEMENTS_MAP = {
        'img'    => 'src',
        'object' => 'data'
      }.freeze

      # @return [String, nil]
      def value
        @value ||= begin
          return unless resolved_value
          return resolved_value unless value_node.matches?('img[alt]')

          {
            value: resolved_value,
            alt: value_node['alt'].strip
          }
        end
      end

      private

      # @return [String, nil]
      def resolved_value
        @resolved_value ||= Absolutely.to_abs(base: node.document.url, relative: unresolved_value.strip) if unresolved_value
      end

      # @return [String, nil]
      def unresolved_value
        @unresolved_value ||= value_node[HTML_ELEMENTS_MAP[value_node.name]] if value_node
      end

      # @return [Nokogiri::XML::Element, nil]
      def value_node
        @value_node ||= begin
          HTML_ELEMENTS_MAP.each do |element, attribute|
            return node if node.matches?("#{element}[#{attribute}]")
          end

          HTML_ELEMENTS_MAP.each do |element, attribute|
            child_node = node.at_css("> #{element}[#{attribute}]:only-of-type")

            return child_node if child_node && !Item.item_node?(child_node) && element == child_node.name && child_node[attribute]
          end

          if node.element_children.one? && !Item.item_node?(node.first_element_child)
            HTML_ELEMENTS_MAP.each do |element, attribute|
              child_node = node.first_element_child.at_css("> #{element}[#{attribute}]:only-of-type")

              return child_node if child_node && !Item.item_node?(child_node) && element == child_node.name && child_node[attribute]
            end
          end

          nil
        end
      end
    end
  end
end
