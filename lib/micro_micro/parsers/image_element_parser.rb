# frozen_string_literal: true

module MicroMicro
  module Parsers
    class ImageElementParser
      # @return [String]
      attr_reader :value

      # @param node [Nokogiri::XML::Element]
      # @param value [String]
      def initialize(node, value)
        @node = node
        @value = value
      end

      # @return [String, nil]
      def alt
        @alt ||= node['alt']&.strip
      end

      # @return [Boolean]
      def alt?
        !alt.nil?
      end

      # @return [Hash{Symbol => String}, nil]
      def srcset
        @srcset ||= parsed_srcset if node['srcset']
      end

      # @return [Boolean]
      def srcset?
        srcset.present?
      end

      # @return [Hash{Symbol => String, Hash{Symbol => String}}]
      def to_h
        hash = { value: value }

        hash[:srcset] = srcset if srcset?
        hash[:alt] = alt if alt?

        hash
      end

      private

      # @return [Nokogiri::XML::Element]
      attr_reader :node

      # @return [Hash{Symbol => String}]
      def parsed_srcset
        node['srcset']
          .split(',')
          .to_h do |candidate|
            candidate.strip.match(/^(.+?)(\s+.+)?$/) do
              [(Regexp.last_match(2) || '1x').strip.to_sym, Regexp.last_match(1)]
            end
          end
      end
    end
  end
end
