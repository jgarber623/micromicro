# frozen_string_literal: true

module MicroMicro
  module Parsers
    class EmbeddedMarkupPropertyParser < BasePropertyParser
      # @see https://microformats.org/wiki/microformats2-parsing#parsing_an_e-_property
      #   microformats.org: microformats2 parsing specification § Parsing an +e-+ property
      #
      # @return [Hash{Symbol => String}]
      def value
        @value ||=
          {
            html: node.inner_html.strip,
            value: super
          }
      end
    end
  end
end
