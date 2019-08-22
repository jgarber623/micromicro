module MicroMicro
  module Parsers
    class RelsParser < BaseRelParser
      private

      def mapped_node_set
        enum_with_obj(Array).each { |node, hash| process_node(node, hash) }.transform_values(&:uniq)
      end

      def process_node(node, hash)
        keys = node['rel'].strip.split(/\s+/).uniq.map(&:to_sym)
        value = Absolutely.to_abs(base: base_url, relative: node['href'].strip)

        keys.each { |rel| hash[rel] << value }
      end
    end
  end
end
