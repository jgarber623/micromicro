module MicroMicro
  module Parsers
    class BaseRelParser
      def initialize(doc, base_url)
        @doc = doc
        @base_url = base_url
      end

      def results
        @results ||= OpenStruct.new(mapped_nodes)
      end

      private

      def base_element
        @base_element ||= @doc.css('base[href]').first
      end

      def enum_with_obj(klass)
        nodes.each_with_object(Hash.new { |hash, key| hash[key] = klass.new })
      end

      def nodes
        @nodes ||= @doc.css('[href][rel]')
      end

      def resolved_base_url
        @resolved_base_url ||= begin
          return @base_url unless base_element

          Absolutely.to_abs(base: @base_url, relative: base_element['href'])
        end
      end
    end
  end
end
