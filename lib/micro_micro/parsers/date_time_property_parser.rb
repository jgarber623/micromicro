module MicroMicro
  module Parsers
    class DateTimePropertyParser < BasePropertyParser
      HTML_ATTRIBUTES_MAP = {
        'datetime' => %w[del ins time],
        'title'    => %w[abbr],
        'value'    => %w[data input]
      }.freeze

      # @see http://microformats.org/wiki/microformats2-parsing#parsing_a_dt-_property
      #
      # @return [String]
      def value
        @value ||= resolved_value || attribute_value || super
      end

      private

      # @see http://microformats.org/wiki/value-class-pattern#microformats2_parsers_implied_date
      #
      # @return [MicroMicro::Parsers::DateTimeParser, nil]
      def adopted_date_time_parser
        @adopted_date_time_parser ||= begin
          collections = property.collection.select { |prop| prop.prefix == 'dt' }.split(property)

          (collections.shift.reverse + collections).flatten.map { |prop| DateTimeParser.new(prop.value) }.find(&:normalized_date)
        end
      end

      # @return [String, nil]
      def attribute_value
        self.class.attribute_value_from(node, HTML_ATTRIBUTES_MAP)
      end

      # @return [MicroMicro::Parsers::DateTimeParser]
      def date_time_parser
        @date_time_parser ||= DateTimeParser.new(ValueClassPatternParser.new(node, ' ').value)
      end

      # @see http://microformats.org/wiki/value-class-pattern#microformats2_parsers_implied_date
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
