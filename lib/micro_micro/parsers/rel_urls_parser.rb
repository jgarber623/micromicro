module MicroMicro
  module Parsers
    class RelUrlsParser < BaseRelParser
      def results
        @results ||= OpenStruct.new(mapped_nodes)
      end

      private

      def mapped_nodes
        @mapped_nodes ||= nodes.each_with_object(obj) do |node, hash|
          key = node['href'].to_sym

          hash[key] = AttributesBuilder.new(node).attributes unless hash.key?(key)
        end
      end

      def obj
        @obj ||= Hash.new { |hash, key| hash[key] = {} }
      end

      class AttributesBuilder
        attr_reader :node

        def initialize(node)
          @node = node
        end

        def attributes
          @attributes ||= OpenStruct.new(selected_attributes)
        end

        private

        def extended_attributes
          {
            hreflang: node['hreflang'],
            media:    node['media'],
            title:    node['title'],
            type:     node['type']
          }.transform_values { |value| (value || '').strip }
        end

        def primary_attributes
          {
            rels: node['rel'].strip.split(/\s+/).uniq.sort,
            text: node.content
          }
        end

        def selected_attributes
          primary_attributes.merge(extended_attributes).select { |_, value| value.present? }
        end
      end
    end
  end
end
