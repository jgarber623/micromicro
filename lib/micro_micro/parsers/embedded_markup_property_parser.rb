module MicroMicro
  module Parsers
    class EmbeddedMarkupPropertyParser < BasePropertyParser
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_an_e-_property
      #
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
