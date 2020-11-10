module MicroMicro
  module Parsers
    class BasePropertyParser
      # @param property [MicroMicro::Property, MicroMicro::ImpliedProperty]
      def initialize(property)
        @property = property
        @node = property.node
      end

      # @see https://microformats.org/wiki/microformats2-parsing#parsing_a_p-_property
      # @see https://microformats.org/wiki/microformats2-parsing#parsing_an_e-_property
      #
      # @return [String]
      def value
        @value ||= begin
          Document.text_content_from(node) do |context|
            context.css('img').each { |img| img.content = " #{img['alt'] || img['src']} " }
          end
        end
      end

      # @param node [Nokogiri::XML::Element]
      # @param attributes_map [Hash{String => Array}]
      # @return [Array]
      def self.attribute_value_from(node, attributes_map)
        attributes_map.map do |attribute, names|
          node[attribute] if names.include?(node.name) && node[attribute]
        end.compact.first
      end

      private

      attr_reader :node, :property
    end
  end
end
