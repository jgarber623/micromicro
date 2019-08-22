module MicroMicro
  module Parsers
    class BaseRelParser
      def initialize(node_set, base_url)
        @node_set = node_set
        @base_url = base_url
      end

      def results
        @results ||= OpenStruct.new(mapped_node_set)
      end

      def self.parse(node_set, base_url)
        new(node_set, base_url).results
      end

      private

      attr_reader :base_url, :node_set

      def enum_with_obj(klass)
        node_set.each_with_object(Hash.new { |hash, key| hash[key] = klass.new })
      end
    end
  end
end
