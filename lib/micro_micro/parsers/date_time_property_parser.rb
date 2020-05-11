module MicroMicro
  module Parsers
    class DateTimePropertyParser < BasePropertyParser
      # @see http://microformats.org/wiki/microformats2-parsing#parsing_a_dt-_property
      HTML_ATTRIBUTES_MAP = {
        'datetime' => %w[del ins time],
        'title'    => %w[abbr],
        'value'    => %w[data input]
      }.freeze

      # @return [String]
      def value
        @value ||= resolved_value || attribute_value || super
      end

      private

      # @return [MicroMicro::Parsers::DateTimeParser, nil]
      def adopted_date_time
        @adopted_date_time ||= begin
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

      # @return [Boolean]
      def imply_date?
        date_time_parser.normalized_time && !date_time_parser.normalized_date
      end

      # @return [String]
      def resolved_value
        return "#{adopted_date_time.normalized_date} #{date_time_parser.value}" if imply_date? && adopted_date_time

        date_time_parser.value
      end
    end
  end
end
