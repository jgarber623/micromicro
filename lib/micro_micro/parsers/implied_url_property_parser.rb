# frozen_string_literal: true

module MicroMicro
  module Parsers
    class ImpliedUrlPropertyParser < BasePropertyParser
      HTML_ELEMENTS_MAP = {
        'a'    => 'href',
        'area' => 'href'
      }.freeze

      # @see https://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      #
      # @return [String, nil]
      def value
        @value ||= value_node[HTML_ELEMENTS_MAP[value_node.name]] if value_node
      end

      private

      # @return [Array<String>]
      def attribute_values
        @attribute_values ||=
          HTML_ELEMENTS_MAP.map do |element, attribute|
            node if node.matches?("#{element}[#{attribute}]")
          end.compact
      end

      # @return [Nokogiri::XML::Element, nil]
      def value_node
        @value_node ||=
          if attribute_values.any?
            attribute_values.first
          else
            HTML_ELEMENTS_MAP.each do |element, attribute|
              child_node = node.at_css("> #{element}[#{attribute}]:only-of-type")

              if child_node && !Item.item_node?(child_node) && element == child_node.name && child_node[attribute]
                return child_node
              end
            end

            if node.element_children.one? && !Item.item_node?(node.first_element_child)
              HTML_ELEMENTS_MAP.each do |element, attribute|
                child_node = node.first_element_child.at_css("> #{element}[#{attribute}]:only-of-type")

                if child_node && !Item.item_node?(child_node) && element == child_node.name && child_node[attribute]
                  return child_node
                end
              end
            end

            nil
          end
      end
    end
  end
end
