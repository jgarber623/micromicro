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
        @srcset ||= image_candidates if node['srcset']
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
      #
      # rubocop:disable Style/PerlBackrefs
      def image_candidates
        node['srcset']
          .split(',')
          .each_with_object({}) do |candidate, hash|
            candidate.strip.match(/^(.+?)(\s+.+)?$/) do
              key = ($2 || '1x').strip.to_sym

              hash[key] = $1 unless hash[key]
            end
          end
      end
      # rubocop:enable Style/PerlBackrefs
    end
  end
end
