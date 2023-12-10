# frozen_string_literal: true

module MicroMicro
  module Parsers
    class ImpliedPhotoPropertyParser < BaseImpliedPropertyParser
      CSS_SELECTORS_ARRAY = ["> img[src]:only-of-type", "> object[data]:only-of-type"].freeze

      HTML_ELEMENTS_MAP = {
        "img"    => "src",
        "object" => "data"
      }.freeze

      # @see https://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      #   microformats.org: microformats2 parsing specification § Parsing for implied properties
      # @see https://microformats.org/wiki/microformats2-parsing#parse_an_img_element_for_src_and_alt
      #   microformats.org: microformats2 parsing specification § Parse an img element for src and alt
      #
      # @return [String, Hash{Symbol => String}, nil]
      def value
        @value ||=
          if attribute_value
            if candidate_node.matches?("img[alt], img[srcset]")
              ImageElementParser.new(candidate_node, attribute_value).to_h
            else
              attribute_value
            end
          end
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
