module MicroMicro
  module Collections
    class PropertiesCollection
      include Collectible

      # @param members [Array<MicroMicro::Property>]
      def initialize(members = [])
        @members = members
      end

      # @return [Hash{Symbol => Array<String, Hash>}]
      def to_h
        group_by(&:name).symbolize_keys.deep_transform_values do |property|
          property.item_node? ? property.value.to_h : property.value
        end
      end

      private

      attr_reader :members
    end
  end
end
