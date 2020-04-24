module MicroMicro
  module Parsers
    class BasePropertyParser
      # @param node [Nokogiri::XML::Element]
      # @param context [Nokogiri::XML::Element, nil]
      def initialize(node, context = nil)
        @node = node
        @context = context
      end

      # @return [String]
      def value
        @value ||= sanitized_node.text.strip
      end

      private

      attr_reader :context, :node

      def sanitized_node
        @sanitized_node ||= begin
          node.css(*Document.ignored_node_names).unlink

          node.css('img').each { |img| img.content = img['alt'] || Absolutely.to_abs(base: node.document.url, relative: img['src']) }

          node
        end
      end
    end
  end
end
