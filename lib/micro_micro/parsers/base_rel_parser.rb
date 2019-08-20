module MicroMicro
  module Parsers
    class BaseRelParser
      def initialize(doc)
        @doc = doc
      end

      private

      def nodes
        @nodes ||= @doc.css('[href][rel]')
      end
    end
  end
end
