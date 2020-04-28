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
      end

      # @return [String, nil]
      def abbreviation
        @abbreviation ||= values[:abbreviation]
      end

      # @return [String, nil]
      def date
        @date ||= [year, month, day].join('-') if year && month && day
      end

      # @return [String, nil]
      def date_time
        @date_time ||= [date, time].join(' ') if date && time
      end

      def date_time_with_offset
        @date_time_with_offset ||= [date, time_with_offset].join(' ') if date && time_with_offset
      end

      # @return [String, nil]
      def day
        @day ||= values[:day]
      end

      # @return [String, nil]
      def hours
        @hours ||= values[:hours]
      end

      # @return [String, nil]
      def minutes
        @minutes ||= values[:minutes]
      end

      # @return [String, nil]
      def month
        @month ||= values[:month]
      end

      # @return [String, nil]
      def normalized_abbreviation
        @normalized_abbreviation ||= abbreviation.tr('.', '').downcase if abbreviation
      end

      # @return [String, nil]
      def normalized_hours
        @normalized_hours ||= begin
          return unless hours
          return (hours.to_i + 12).to_s if normalized_abbreviation == 'pm'

          "%02d" % hours
        end
      end

      # @return [String, nil]
      def normalized_minutes
        @normalized_minutes ||= (hours && !minutes) ? '00' : minutes
      end

      # @return [String, nil]
      def normalized_offset
        @normalized_offset ||= offset.tr(':', '') if offset
      end

      # @return [String, nil]
      def offset
        @offset ||= values[:zulu] || values[:offset]
      end

      # @return [String, nil]
      def ordinal_date
        @ordinal_date ||= [year, ordinal].join('-') if year && ordinal
      end

      # @return [String, nil]
      def seconds
        @seconds ||= values[:seconds]
      end

      # @return [String, nil]
      def time
        @time ||= [normalized_hours, normalized_minutes, seconds].compact.join(':') if normalized_hours
      end

      # @return [String, nil]
      def time_with_offset
        @time_with_offset || [time, normalized_offset].join if time && normalized_offset
      end

      def value
        @value ||= date_time_with_offset || date_time || date || time_with_offset || time || offset || nil
      end

      # @return [String, nil]
      def year
        @year ||= values[:year]
      end

      # @return [Hash{Symbol => String, nil}]
      def values
        @values ||= self.class.values_from(string)
      end

      # @return [Boolean]
      def values?
        values.any?
      end

      # @param string [String]
      # @return [Hash{Symbol => String, nil}]
      def self.values_from(string)
        (string.match(%r{^(?:#{DATE_REGEXP_PATTERN})?(?:\s?#{TIME_REGEXP_PATTERN}(?:#{TIMEZONE_REGEXP_PATTERN})?)?$})&.named_captures || {}).symbolize_keys
      end

      private

      attr_reader :string
    end
  end
end
