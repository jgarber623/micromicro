# frozen_string_literal: true

module MicroMicro
  module Parsers
    class BasePropertyParser
      # @param property [MicroMicro::Property, MicroMicro::ImpliedProperty]
      def initialize(property)
        @property = property
        @node = property.node
      end

      # @see https://microformats.org/wiki/microformats2-parsing#parsing_a_p-_property
      #   microformats.org: microformats2 parsing specification § Parsing a +p-+ property
      # @see https://microformats.org/wiki/microformats2-parsing#parsing_an_e-_property
      #   microformats.org: microformats2 parsing specification § Parsing an +e-+ property
      #
      # @return [String]
      def value
        @value ||=
          Helpers.text_content_from(node) do |context|
            context.css("img").each { |img| img.content = " #{img['alt'] || img['src']} " }
          end
      end

      private

      attr_reader :node, :property
    end
  end
end
