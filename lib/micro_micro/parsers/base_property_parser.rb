module MicroMicro
  module Parsers
    class BasePropertyParser
      # @param property [MicroMicro::Property, MicroMicro::ImpliedProperty]
      def initialize(property)
        @property = property
        @node = property.node
      end

      # @return [String]
      def value
        @value ||= serialized_node.text.strip
      end

      private

      attr_reader :node, :property

      # @see microformats2 Parsing Specification sections 1.3.1 and 1.3.4
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_a_p-_property
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_an_e-_property
      def serialized_node
        @serialized_node ||= begin
          node.css(*Document.ignored_node_names).unlink

          node.css('img').each { |img| img.content = " #{img['alt'] || Absolutely.to_abs(base: node.document.url, relative: img['src'])} " }

          node
        end
      end
    end
  end
end
