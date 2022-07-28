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
        @value ||=
          if resolved_value
            return resolved_value unless value_node.matches?('img[alt]')

            {
              value: resolved_value,
              alt: value_node['alt'].strip
            }
          end
      end

      private

      # @return [Array<Nokogiri::XML::Element>]
      def attribute_values
        @attribute_values ||=
          HTML_ELEMENTS_MAP.filter_map do |element, attribute|
            node if node.matches?("#{element}[#{attribute}]")
          end
      end

      # @return [String, nil]
      def resolved_value
        @resolved_value ||= value_node[HTML_ELEMENTS_MAP[value_node.name]] if value_node
      end

      # @return [Nokogiri::XML::Element, nil]
      def value_node
        @value_node ||=
          if attribute_values.any?
            attribute_values.first
          else
            HTML_ELEMENTS_MAP.each do |element, attribute|
              child_node = node.at_css("> #{element}[#{attribute}]:only-of-type")

              if child_node && !Helpers.item_node?(child_node) && element == child_node.name && child_node[attribute]
                return child_node
              end
            end

            if node.element_children.one? && !Helpers.item_node?(node.first_element_child)
              HTML_ELEMENTS_MAP.each do |element, attribute|
                child_node = node.first_element_child.at_css("> #{element}[#{attribute}]:only-of-type")

                if child_node && !Helpers.item_node?(child_node) && element == child_node.name && child_node[attribute]
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
