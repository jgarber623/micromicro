module MicroMicro
  module Parsers
    class ImpliedNamePropertyParser < BasePropertyParser
      # @see microformats2 Parsing Specification section 1.3.5
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      HTML_ATTRIBUTE_MAP = {
        'alt'   => %w[area img],
        'title' => %w[abbr]
      }.freeze

      def value
        @value ||= unresolved_value.strip
      end

      private

      def unresolved_value
        return node['alt'] if %w[img area].include?(node.name)
        return node['title'] if node.name == 'abbr'

        if node.element_children.one?
          child_node = node.first_element_child

          unless Item.item_node?(child_node)
            return child_node['alt'] if %w[img area].include?(child_node.name) && child_node['alt'].present?
            return child_node['title'] if child_node.name == 'abbr' && child_node['title'].present?

            if child_node.element_children.one?
              grandchild_node = child_node.first_element_child

              unless Item.item_node?(grandchild_node)
                return grandchild_node['alt'] if %w[img area].include?(grandchild_node.name) && grandchild_node['alt'].present?
                return grandchild_node['title'] if grandchild_node.name == 'abbr' && grandchild_node['title'].present?
              end
            end
          end
        end

        sanitized_node.css('img').each { |img| img.content = img['alt'] }

        sanitized_node.text
      end
    end
  end
end
