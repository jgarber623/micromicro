# frozen_string_literal: true

module MicroMicro
  module Collections
    class ItemsCollection < BaseCollection
      # Return an Array of this collection's {MicroMicro::Item}s as Hashes.
      #
      # @see MicroMicro::Item#to_h
      #
      # @return [Array<Hash{Symbol => Array<String, Hash>}>]
      def to_a
        map(&:to_h)
      end

      # Retrieve a unique Array of this collection's {MicroMicro::Item}s' types.
      #
      # @see MicroMicro::Item#types
      #
      # @return [Array<String>]
      def types
        @types ||= flat_map(&:types).uniq.sort
      end
    end
  end
end
