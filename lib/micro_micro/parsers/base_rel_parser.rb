module MicroMicro
  module Parsers
    class BaseRelParser
      def initialize(doc)
        @doc = doc
      end

      def results
        @results ||= OpenStruct.new(mapped_nodes)
      end

      private

      def enum_with_obj(klass)
        nodes.each_with_object(Hash.new { |hash, key| hash[key] = klass.new })
      end

      def nodes
        @nodes ||= @doc.css('[href][rel]')
      end
    end
  end
end
