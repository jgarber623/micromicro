# frozen_string_literal: true

module MicroMicro
  module Parsers
    class PlainTextPropertyParser < BasePropertyParser
      HTML_ATTRIBUTES_MAP = {
        'title' => %w[abbr link],
        'value' => %w[data input],
        'alt'   => %w[area img]
      }.freeze

      # @see https://microformats.org/wiki/microformats2-parsing#parsing_a_p-_property
      #
      # @return [String]
      def value
        @value ||= value_class_pattern_value || attribute_value || super
      end

      private

      # @return [String, nil]
      def attribute_value
        Helpers.attribute_value_from(node, HTML_ATTRIBUTES_MAP)
      end

      # @return [String, nil]
      def value_class_pattern_value
        ValueClassPatternParser.new(node).value
      end
    end
  end
end
