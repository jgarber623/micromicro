# frozen_string_literal: true

module MicroMicro
  module Parsers
    class BaseImpliedPropertyParser < BasePropertyParser
      private

      # @return [String, nil]
      def attribute_value
        candidate_node[self.class::HTML_ELEMENTS_MAP[candidate_node.name]] if candidate_node
      end

      # @return [Nokogiri::XML::Element, nil]
      def candidate_node
        @candidate_node ||=
          candidate_nodes.find do |node|
            self.class::HTML_ELEMENTS_MAP.filter_map do |name, attribute|
              node if name == node.name && node[attribute]
            end.any?
          end
      end

      # @return [Nokogiri::XML::NodeSet]
      def candidate_nodes
        Nokogiri::XML::NodeSet.new(node.document, child_nodes.unshift(node))
      end
    end
  end
end
