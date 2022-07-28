# frozen_string_literal: true

module MicroMicro
  module Parsers
    class ImpliedNamePropertyParser < BasePropertyParser
      HTML_ATTRIBUTES_MAP = {
        'alt'   => %w[area img],
        'title' => %w[abbr]
      }.freeze

      # @see https://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      #
      # @return [String]
      def value
        @value ||= attribute_value || text_content
      end

      private

      # @return [String, nil]
      def attribute_value
        candidate_nodes.filter_map { |node| Helpers.attribute_value_from(node, HTML_ATTRIBUTES_MAP) }.first
      end

      # @return [Nokogiri::XML::NodeSet]
      def candidate_nodes
        @candidate_nodes ||= Nokogiri::XML::NodeSet.new(node.document, child_nodes.unshift(node))
      end

      # @return [Array]
      def child_nodes
        [
          node.at_css('> :only-child'),
          node.at_css('> :only-child > :only-child')
        ].compact.reject { |child_node| Helpers.item_node?(child_node) }
      end

      # @return [String]
      def text_content
        @text_content ||=
          Helpers.text_content_from(node) do |context|
            context.css('img').each { |img| img.content = img['alt'] }
          end
      end
    end
  end
end
