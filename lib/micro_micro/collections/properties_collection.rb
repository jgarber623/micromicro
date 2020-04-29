module MicroMicro
  module Collections
    class PropertiesCollection
      include Collectible

      # @param node_set [Nokogiri::XML::NodeSet]
      def initialize(node_set)
        @node_set = node_set
      end

      # @return [Array<MicroMicro::Property>]
      def members
        @members ||= node_set.map { |node| properties_from(node) }.flatten
      end

      # @return [Hash{Symbol => Array<String, Hash>}]
      def to_h
        members.group_by(&:name).symbolize_keys.deep_transform_values do |property|
          property.item_node? ? property.value.to_h : property.value
        end
      end

      private

      attr_reader :node_set

      # @return [Array<MicroMicro::Property>]
      def properties_from(node)
        Property.types_from(node).map do |prefix, name|
          Property.new(node, name: name, prefix: prefix)
        end
      end
    end
  end
end
