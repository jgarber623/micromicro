module MicroMicro
  module Parsers
    class EmbeddedMarkupPropertyParser < BasePropertyParser
      # @return [Hash{Symbol => String}]
      def value
        @value ||= begin
          {
            html: node.inner_html.strip,
            value: super
          }
        end
      end
    end
  end
end
