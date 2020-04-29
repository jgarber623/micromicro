module MicroMicro
  module Parsers
    class DateTimeParser
      # @see Value Class Pattern section 4.2
      # @see http://microformats.org/wiki/value-class-pattern#Date_and_time_parsing
      #
      # Regexp pattern matching YYYY-MM-DD and YYY-DDD
      DATE_REGEXP_PATTERN = '(?<year>\d{4})-((?<ordinal>3[0-6]{2}|[0-2]\d{2})|(?<month>0\d|1[0-2])-(?<day>3[0-1]|[0-2]\d))'.freeze
      # Regexp pattern matching HH:MM and HH:MM:SS
      TIME_REGEXP_PATTERN = '(?<hours>2[0-3]|[0-1]?\d)(?::(?<minutes>[0-5]\d))?(?::(?<seconds>[0-5]\d))?(?:\s*?(?<abbreviation>[apPP]\.?[mM]\.?))?'.freeze
      # Regexp pattern matching +/-(XX:YY|XXYY|XX) or the literal string Z
      TIMEZONE_REGEXP_PATTERN = '(?<zulu>Z)|(?<offset>(?:\+|-)(?:1[0-2]|0?\d)(?::?[0-5]\d)?)'.freeze

      # @param string [String]
      def initialize(string)
        @string = string

        values.each do |name, value|
          define_singleton_method(name) { value }
          define_singleton_method("#{name}?") { value.present? }
        end
      end

      def normalized_date
        @normalized_date ||= "#{year}-#{month}-#{day}" if year? && month? && day?
      end

      def normalized_hours
        @normalized_hours ||= begin
          return unless hours?
          return (hours.to_i + 12).to_s if abbreviation&.tr('.', '')&.downcase == 'pm'

          format('%<hours>02d', hours: hours)
        end
      end

      def normalized_minutes
        @normalized_minutes ||= minutes || '00'
      end

      def normalized_ordinal_date
        @normalized_ordinal_date ||= "#{year}-#{ordinal}" if year? && ordinal?
      end

      def normalized_time
        @normalized_time ||= [normalized_hours, normalized_minutes, seconds].compact.join(':') if normalized_hours
      end

      def normalized_timezone
        @normalized_timezone ||= zulu || offset&.tr(':', '')
      end

      def value
        @value ||= "#{normalized_date} #{normalized_time}#{normalized_timezone}".strip
      end

      def values
        @values ||= self.class.values_from(string)
      end

      # @param string [String]
      # @return [Hash{Symbol => String, nil}]
      def self.values_from(string)
        string.match(/^(?:#{DATE_REGEXP_PATTERN})?(?:\s?#{TIME_REGEXP_PATTERN}(?:#{TIMEZONE_REGEXP_PATTERN})?)?$/)&.named_captures.to_h.symbolize_keys
      end

      private

      attr_reader :string
    end
  end
end
