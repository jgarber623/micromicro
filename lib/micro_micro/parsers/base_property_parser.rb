module MicroMicro
  module Parsers
    class BasePropertyParser
      # @param node [Nokogiri::XML::Element]
      def initialize(node)
        @node = node
      end

      # @return [Nokogiri::XML::NodeSet]
      def node_set
        @node_set ||= Nokogiri::XML::NodeSet.new(node.document, [node])
      end

      # @return [String]
      def value
        @value ||= serialized_node.text.strip
      end

      # @see microformats2 Parsing Specification section 1.5
      # @see http://microformats.org/wiki/microformats2-parsing#parse_an_img_element_for_src_and_alt
      #
      # @return [String, Hash{Symbol => String}]
      def self.structured_value_from(node, value)
        return value unless node.name == 'img' && node['alt']

        {
          value: value,
          alt: node['alt'].strip
        }
      end

      private

      attr_reader :node

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
