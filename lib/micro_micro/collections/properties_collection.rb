module MicroMicro
  module Collections
    class PropertiesCollection < BaseCollection
      # @return [Array<String>]
      def names
        @names ||= map(&:name).uniq.sort
      end

      # @return [Hash{Symbol => Array<String, Hash>}]
      def to_h
        group_by(&:name).symbolize_keys.deep_transform_values(&:value)
      end

      # @return [Array<String, Hash>]
      def values
        @values ||= map(&:value).uniq
      end
    end
  end
end
