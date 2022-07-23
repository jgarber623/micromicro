# frozen_string_literal: true

module MicroMicro
  module Collections
    class ItemsCollection < BaseCollection
      # @return [Array<Hash{Symbol => Array<String, Hash>}>]
      def to_a
        map(&:to_h)
      end

      # @return [Array<String>]
      def types
        @types ||= flat_map(&:types).uniq.sort
      end
    end
  end
end
