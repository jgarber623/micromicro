module MicroMicro
  module Collections
    class ItemsCollection
      include Collectible

      # @param node_set [Nokogiri::XML::NodeSet]
      def initialize(node_set)
        @node_set = node_set
      end

      # @return [Array<MicroMicro::Item>]
      def members
        @members ||= node_set.map { |node| Item.new(node) }
      end

      # @return [Array<Hash{Symbol => Array<String, Hash>}>]
      def to_a
        members.map(&:to_h)
      end

      private

      attr_reader :node_set
    end
  end
end
