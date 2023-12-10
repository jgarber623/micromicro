# frozen_string_literal: true

module MicroMicro
  module Parsers
    class ImpliedUrlPropertyParser < BaseImpliedPropertyParser
      CSS_SELECTORS_ARRAY = ["> a[href]:only-of-type", "> area[href]:only-of-type"].freeze

      HTML_ELEMENTS_MAP = {
        "a"    => "href",
        "area" => "href"
      }.freeze

      # @see https://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      #   microformats.org: microformats2 parsing specification § Parsing for implied properties
      #
      # @return [String, nil]
      def value
        @value ||= attribute_value
      end

      private

      # @return [Array]
      def child_nodes
        nodes = [node.at_css(*CSS_SELECTORS_ARRAY)]

        nodes << node.first_element_child.at_css(*CSS_SELECTORS_ARRAY) if node.element_children.one?

        nodes.reject { |child_node| child_node.nil? || Helpers.item_node?(child_node) }
      end
    end
  end
end
