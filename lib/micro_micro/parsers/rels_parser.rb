module MicroMicro
  module Parsers
    class RelsParser < BaseRelParser
      def results
        @results ||= OpenStruct.new(mapped_nodes.transform_values(&:uniq))
      end

      def self.symbols_from(value)
        value.strip.split(/\s+/).uniq.map(&:to_sym)
      end

      private

      def mapped_nodes
        @mapped_nodes ||= nodes.each_with_object(obj) do |node, hash|
          self.class.symbols_from(node['rel']).each { |rel| hash[rel] << node['href'].strip }
        end
      end

      def obj
        @obj ||= Hash.new { |hash, key| hash[key] = [] }
      end
    end
  end
end
