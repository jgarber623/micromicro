module MicroMicro
  module Collections
    class PropertiesCollection < BaseCollection
      # @return [Hash{Symbol => Array<String, Hash>}]
      def to_h
        group_by(&:name).symbolize_keys.deep_transform_values(&:value)
      end
    end
  end
end
