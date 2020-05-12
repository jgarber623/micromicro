module MicroMicro
  module Collections
    class PropertiesCollection < BaseCollection
      # @return [Hash{Symbol => Array<String, Hash>}]
      def to_h
        group_by(&:name).symbolize_keys.deep_transform_values(&:value)
      end

      private

      def decorate_members
        each { |member| member.collection = self }
      end
    end
  end
end
