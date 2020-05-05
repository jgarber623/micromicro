module MicroMicro
  module Collections
    class ItemsCollection < BaseCollection
      # @return [Array<Hash{Symbol => Array<String, Hash>}>]
      def to_a
        map(&:to_h)
      end
    end
  end
end
