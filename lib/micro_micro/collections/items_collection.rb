module MicroMicro
  module Collections
    class ItemsCollection
      include Collectible

      # @param members [Array<MicroMicro::Item>]
      def initialize(members = [])
        @members = members
      end

      # @return [Array<Hash{Symbol => Array<String, Hash>}>]
      def to_a
        map(&:to_h)
      end

      private

      attr_reader :members
    end
  end
end
