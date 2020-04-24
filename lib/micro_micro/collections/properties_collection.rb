module MicroMicro
  module Collections
    class PropertiesCollection
      include Collectible

      # @param node_set [Nokogiri::XML::NodeSet]
      # @param context [Nokogiri::XML::Element]
      def initialize(node_set, context)
        @node_set = node_set
        @context = context
      end

      # @return [Array<MicroMicro::Property>]
      def members
        @members ||= begin
          node_set.map do |node|
            Property.types_from(node).map do |prefix, name|
              Property.new(node, context, name: name, prefix: prefix)
            end
          end.flatten
        end
      end

      # @return [Hash{Symbol => Array<String, Hash>}]
      def to_h
        members.group_by(&:name).symbolize_keys.deep_transform_values do |property|
          property.item_node? ? property.value.to_h : property.value
        end
      end

      private

      attr_reader :node_set, :context
    end
  end
end
