# frozen_string_literal: true

module MicroMicro
  module Collections
    class PropertiesCollection < BaseCollection
      # @return [Array<String>]
      def names
        @names ||= map(&:name).uniq.sort
      end

      # @return [MicroMicro::Collections::PropertiesCollection]
      def plain_text_properties
        self.class.new(select(&:plain_text_property?))
      end

      # @return [Hash{Symbol => Array<String, Hash>}]
      def to_h
        group_by(&:name).symbolize_keys.deep_transform_values(&:value)
      end

      # @return [MicroMicro::Collections::PropertiesCollection]
      def url_properties
        self.class.new(select(&:url_property?))
      end

      # @return [Array<String, Hash>]
      def values
        @values ||= map(&:value).uniq
      end
    end
  end
end
