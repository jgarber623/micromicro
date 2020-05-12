module MicroMicro
  module Parsers
    class ImpliedNamePropertyParser < BasePropertyParser
      HTML_ATTRIBUTES_MAP = {
        'alt'   => %w[area img],
        'title' => %w[abbr]
      }.freeze

      # @see http://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
      #
      # @return [String]
      def value
        @value ||= attribute_value || text_content
      end

      private

      # @return [Nokogiri::XML::NodeSet]
      def candidate_nodes
        @candidate_nodes ||= Nokogiri::XML::NodeSet.new(node.document, child_nodes.unshift(node))
      end

      # @return [Array]
      def child_nodes
        [node.at_css('> :only-child'), node.at_css('> :only-child > :only-child')].compact.reject { |child_node| Item.item_node?(child_node) }
      end

      # @return [String, nil]
      def attribute_value
        candidate_nodes.map { |node| self.class.attribute_value_from(node, HTML_ATTRIBUTES_MAP) }.compact.first
      end

      # @return [String]
      def text_content
        @text_content ||= Document.text_content_from(node) { |context| context.css('img').each { |img| img.content = img['alt'] } }
      end
    end
  end
end
