# frozen_string_literal: true

module MicroMicro
  module Parsers
    class ImpliedPhotoPropertyParser < BasePropertyParser
      HTML_ELEMENTS_MAP = {
        'img'    => 'src',
        'object' => 'data'
      }.freeze

      # @see https://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      # @see https://microformats.org/wiki/microformats2-parsing#parse_an_img_element_for_src_and_alt
      #
      # @return [String, Hash{Symbol => String}, nil]
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

      # @return [Array<String>]
      def attribute_values
        @attribute_values ||= begin
          HTML_ELEMENTS_MAP.map do |element, attribute|
            node if node.matches?("#{element}[#{attribute}]")
          end.compact
        end
      end

      # @return [String, nil]
      def resolved_value
        @resolved_value ||= value_node[HTML_ELEMENTS_MAP[value_node.name]] if value_node
      end

      # @return [Nokogiri::XML::Element, nil]
      def value_node
        @value_node ||= begin
          return attribute_values.first if attribute_values.any?

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
