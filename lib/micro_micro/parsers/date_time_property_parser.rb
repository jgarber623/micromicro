# frozen_string_literal: true

module MicroMicro
  module Parsers
    class DateTimePropertyParser < BasePropertyParser
      HTML_ATTRIBUTES_MAP = {
        "datetime" => %w[del ins time],
        "title"    => %w[abbr],
        "value"    => %w[data input]
      }.freeze

      # @see https://microformats.org/wiki/microformats2-parsing#parsing_a_dt-_property
      #   microformats.org: microformats2 parsing specification § Parsing a +dt-+ property
      #
      # @return [String]
      def value
        @value ||= resolved_value || attribute_value || super
      end

      private

      # @see https://microformats.org/wiki/value-class-pattern#microformats2_parsers_implied_date
      #   microformats.org: Value Class Pattern § microformats2 parsers implied date
      #
      # @return [MicroMicro::Parsers::DateTimeParser, nil]
      def adopted_date_time_parser
        @adopted_date_time_parser ||=
          (property.prev_all.reverse + property.next_all).filter_map do |prop|
            DateTimeParser.new(prop.value) if prop.date_time_property?
          end.find(&:normalized_date)
      end

      # @return [String, nil]
      def attribute_value
        Helpers.attribute_value_from(node, HTML_ATTRIBUTES_MAP)
      end

      # @return [MicroMicro::Parsers::DateTimeParser]
      def date_time_parser
        @date_time_parser ||= DateTimeParser.new(ValueClassPatternParser.new(node, " ").value)
      end

      # @see https://microformats.org/wiki/value-class-pattern#microformats2_parsers_implied_date
      #   microformats.org: Value Class Pattern § microformats2 parsers implied date
      #
      # @return [Boolean]
      def imply_date?
        date_time_parser.normalized_time && !date_time_parser.normalized_date && adopted_date_time_parser
      end

      # @return [String]
      def resolved_value
        return "#{adopted_date_time_parser.normalized_date} #{date_time_parser.value}" if imply_date?

        date_time_parser.value
      end
    end
  end
end
