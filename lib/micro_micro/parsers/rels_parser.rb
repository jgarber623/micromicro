module MicroMicro
  module Parsers
    class RelsParser < BaseRelParser
      private

      def mapped_nodes
        enum_with_obj(Array).each { |node, hash| process_node(node, hash) }.transform_values(&:uniq)
      end

      def process_node(node, hash)
        keys = node['rel'].strip.split(/\s+/).uniq.map(&:to_sym)

        keys.each { |rel| hash[rel] << node['href'].strip }
      end
    end
  end
end
