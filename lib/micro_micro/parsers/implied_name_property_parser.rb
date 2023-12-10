# frozen_string_literal: true

module MicroMicro
  module Parsers
    class ImpliedNamePropertyParser < BaseImpliedPropertyParser
      HTML_ELEMENTS_MAP = {
        "img"  => "alt",
        "area" => "alt",
        "abbr" => "title"
      }.freeze

      # @see https://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      #   microformats.org: microformats2 parsing specification § Parsing for implied properties
      #
      # @return [String]
      def value
        @value ||= attribute_value || text_content
      end

      private

      # @return [Array]
      def child_nodes
        [
          node.at_css("> :only-child"),
          node.at_css("> :only-child > :only-child")
        ].reject { |child_node| child_node.nil? || Helpers.item_node?(child_node) }
      end

      # @return [String]
      def text_content
        Helpers.text_content_from(node) do |context|
          context.css("img").each { |img| img.content = img["alt"] }
        end
      end
    end
  end
end
