module MicroMicro
  module Parsers
    class ImpliedPhotoPropertyParser < BasePropertyParser
      # @see microformats2 Parsing Specification section 1.3.5
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      HTML_ATTRIBUTE_MAP = [
        %w[img src],
        %w[object data]
      ].freeze

      def value
        @value ||= begin
          return unless unresolved_value

          Absolutely.to_abs(base: node.document.url, relative: unresolved_value.strip)
        end
      end

      private

      # TODO: Parse <img> for src and alt
      # http://microformats.org/wiki/microformats2-parsing#parse_an_img_element_for_src_and_alt
      def unresolved_value
        HTML_ATTRIBUTE_MAP.each do |element, attribute|
          return node[attribute] if element == node.name && node[attribute].present?
        end

        HTML_ATTRIBUTE_MAP.each do |element, attribute|
          child_node = node.at_css("> #{element}[#{attribute}]:only-of-type")

          return child_node[attribute] if child_node && child_node[attribute].present? && !Item.item_node?(child_node)
        end

        if node.element_children.one?
          child_node = node.element_children.first

          if child_node && !Item.item_node?(child_node)
            HTML_ATTRIBUTE_MAP.each do |element, attribute|
              grandchild_node = child_node.at_css("> #{element}[#{attribute}]:only-of-type")

              return grandchild_node[attribute] if grandchild_node && grandchild_node[attribute].present? && !Item.item_node?(grandchild_node)
            end
          end
        end

        nil
      end
    end
  end
end
