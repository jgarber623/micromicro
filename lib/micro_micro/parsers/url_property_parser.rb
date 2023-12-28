# frozen_string_literal: true

module MicroMicro
  module Parsers
    class UrlPropertyParser < BasePropertyParser
      HTML_ATTRIBUTES_MAP = {
        "href"   => ["a", "area", "link"],
        "src"    => ["audio", "iframe", "img", "source", "video"],
        "poster" => ["video"],
        "data"   => ["object"]
      }.freeze

      EXTENDED_HTML_ATTRIBUTES_MAP = {
        "title" => ["abbr"],
        "value" => ["data", "input"]
      }.freeze

      # @see https://microformats.org/wiki/microformats2-parsing#parsing_a_u-_property
      #   microformats.org: microformats2 parsing specification § Parsing a +u-+ property
      # @see https://microformats.org/wiki/microformats2-parsing#parse_an_img_element_for_src_and_alt
      #   microformats.org: microformats2 parsing specification § Parse an img element for src and alt
      #
      # @return [String, Hash{Symbol => String}]
      def value
        @value ||=
          if node.matches?("img[alt], img[srcset]")
            ImageElementParser.new(node, resolved_value).to_h
          else
            resolved_value
          end
      end

      private

      # @return [String, nil]
      def attribute_value
        Helpers.attribute_value_from(node, HTML_ATTRIBUTES_MAP)
      end

      # @return [String, nil]
      def extended_attribute_value
        Helpers.attribute_value_from(node, EXTENDED_HTML_ATTRIBUTES_MAP)
      end

      # @return [String]
      def resolved_value
        @resolved_value ||= node.document.resolve_relative_url(unresolved_value.strip)
      end

      # @return [String]
      def text_content
        Helpers.text_content_from(node)
      end

      # @return [String]
      def unresolved_value
        attribute_value || value_class_pattern_value || extended_attribute_value || text_content
      end

      # @return [String, nil]
      def value_class_pattern_value
        ValueClassPatternParser.new(node).value
      end
    end
  end
end
