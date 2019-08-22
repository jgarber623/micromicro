module MicroMicro
  module Parsers
    class RelUrlsParser < BaseRelParser
      private

      def mapped_node_set
        enum_with_obj(Hash).each { |node, hash| process_node(node, hash) }
      end

      def process_node(node, hash)
        key = Absolutely.to_abs(base: base_url, relative: node['href'].strip).to_sym

        hash[key] = AttributesBuilder.new(node).attributes unless hash.key?(key)
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

        def base_attributes
          {
            rels: node['rel'].strip.split(/\s+/).uniq.sort,
            text: node.content
          }
        end

        def extended_attributes
          node.attributes.select { |key, _| %w[hreflang media title type].include?(key) }.transform_values { |value| value.to_s.strip }
        end

        def selected_attributes
          base_attributes.merge(extended_attributes).select { |_, value| value.present? }
        end
      end
    end
  end
end
