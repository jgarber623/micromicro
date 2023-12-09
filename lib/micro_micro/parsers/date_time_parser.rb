# frozen_string_literal: true

module MicroMicro
  module Parsers
    class DateTimeParser
      # Regexp pattern matching YYYY-MM-DD and YYY-DDD
      DATE_REGEXP_PATTERN = '(?<year>\d{4})-' \
                            '((?<ordinal>3[0-6]{2}|[0-2]\d{2})|(?<month>0\d|1[0-2])-' \
                            '(?<day>3[0-1]|[0-2]\d))'

      # Regexp pattern matching HH:MM and HH:MM:SS
      TIME_REGEXP_PATTERN = '(?<hours>2[0-3]|[0-1]?\d)' \
                            '(?::(?<minutes>[0-5]\d))?' \
                            '(?::(?<seconds>[0-5]\d))?' \
                            '(?:\s*?(?<abbreviation>[apPP]\.?[mM]\.?))?'

      # Regexp pattern matching +/-(XX:YY|XXYY|XX) or the literal string Z
      TIMEZONE_REGEXP_PATTERN = '(?<zulu>Z)|(?<offset>(?:\+|-)(?:1[0-2]|0?\d)(?::?[0-5]\d)?)'

      # Regexp for extracting named captures from a datetime-esque String.
      DATE_TIME_TIMEZONE_REGEXP = /
        \A
        (?=.)
        (?:#{DATE_REGEXP_PATTERN})?
        (?:\s?#{TIME_REGEXP_PATTERN}(?:#{TIMEZONE_REGEXP_PATTERN})?)?
        \z
      /x

      # Parse a string for date and/or time values according to the Microformats
      # Value Class Pattern date and time parsing specification.
      #
      # @see https://microformats.org/wiki/value-class-pattern#Date_and_time_parsing
      #   microformats.org: Value Class Pattern § Date and time parsing
      #
      # @param string [String, #to_s]
      def initialize(string)
        @string = string.to_s
      end

      # Define getter and predicate methods for all possible named captures
      # returned by the DATE_TIME_TIMEZONE_REGEXP regular expression.
      %i[year ordinal month day hours minutes seconds abbreviation zulu offset].each do |name|
        define_method(name) { values[name] }
        define_method("#{name}?") { public_send(name).present? }
      end

      # @return [String, nil]
      def normalized_calendar_date
        @normalized_calendar_date ||= "#{year}-#{month}-#{day}" if year? && month? && day?
      end

      # @return [String, nil]
      def normalized_date
        @normalized_date ||= normalized_calendar_date || normalized_ordinal_date
      end

      # @return [String, nil]
      def normalized_hours
        @normalized_hours ||=
          if hours?
            return (hours.to_i + 12).to_s if abbreviation&.tr(".", "")&.downcase == "pm"

            format("%<hours>02d", hours: hours)
          end
      end

      # @return [String]
      def normalized_minutes
        @normalized_minutes ||= minutes || "00"
      end

      # @return [String, nil]
      def normalized_ordinal_date
        @normalized_ordinal_date ||= "#{year}-#{ordinal}" if year? && ordinal?
      end

      # @return [String, nil]
      def normalized_time
        @normalized_time ||= [normalized_hours, normalized_minutes, seconds].compact.join(":") if normalized_hours
      end

      # @return [String, nil]
      def normalized_timezone
        @normalized_timezone ||= zulu || offset&.tr(":", "")
      end

      # @return [String, nil]
      def value
        @value ||= "#{normalized_date} #{normalized_time}#{normalized_timezone}".strip.presence
      end

      # @return [Hash{Symbol => String, nil}]
      def values
        @values ||=
          if string.match?(DATE_TIME_TIMEZONE_REGEXP)
            string.match(DATE_TIME_TIMEZONE_REGEXP).named_captures.transform_keys(&:to_sym)
          else
            {}
          end
      end

      private

      # @return [String]
      attr_reader :string
    end
  end
end
