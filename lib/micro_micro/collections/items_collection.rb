# frozen_string_literal: true

module MicroMicro
  module Collections
    class ItemsCollection < BaseCollection
      class ItemsCollectionSearch
        attr_reader :results

        def initialize
          @results = []
        end

        def search(items, **args, &block)
          items.each do |item|
            results << item if item_matches_conditions?(item, **args, &block)

            search(item.properties.filter_map { |property| property.item if property.item_node? }, **args, &block)
            search(item.children, **args, &block)
          end

          results
        end

        private

        def item_matches_conditions?(item, **args)
          return yield(item) if args.none?

          args.all? { |key, value| (Array(item.public_send(key.to_sym)) & Array(value)).any? }
        end
      end

      private_constant :ItemsCollectionSearch

      # Return the first {MicroMicro::Item} from a search.
      #
      # @see #where
      #
      # @param (see #where)
      # @yieldparam (see #where))
      # @return [MicroMicro::Item, nil]
      def find_by(**args, &block)
        where(**args, &block).first
      end

      # Return an Array of this collection's {MicroMicro::Item}s as Hashes.
      #
      # @see MicroMicro::Item#to_h
      #
      # @return [Array<Hash{Symbol => Array<String, Hash>}>]
      def to_a
        map(&:to_h)
      end

      # Retrieve an Array of this collection's unique {MicroMicro::Item} types.
      #
      # @see MicroMicro::Item#types
      #
      # @return [Array<String>]
      def types
        @types ||= flat_map(&:types).uniq.sort
      end

      # Recursively search this collection for {MicroMicro::Item}s matching the
      # given conditions.
      #
      # If a Hash is supplied, the returned collection will include
      # {MicroMicro::Item}s matching _all_ conditions. Keys must be Symbols
      # matching an instance method on {MicroMicro::Item} and values may be
      # either a String or an Array of Strings.
      #
      # @example Search using a Hash with a String value
      #   MicroMicro.parse(markup, url).items.where(types: 'h-card')
      #
      # @example Search using a Hash with an Array value
      #   MicroMicro.parse(markup, url).items.where(types: ['h-card', 'h-entry'])
      #
      # When passing a block, each {MicroMicro::Item} in this collection is
      # yielded to the block and the returned collection will include
      # {MicroMicro::Item}s that cause the block to return a value other than
      # +false+ or +nil+.
      #
      # @example Search using a block
      #   MicroMicro.parse(markup, url).items.where do |item|
      #     item.properties.names.include?('email')
      #   end
      #
      # @param args [Hash{Symbol => String, Array<String>}]
      # @yieldparam item [MicroMicro::Item]
      # @return [MicroMicro::Collections::ItemsCollection]
      def where(**args, &block)
        return self if args.none? && !block

        self.class.new(ItemsCollectionSearch.new.search(self, **args, &block))
      end
    end
  end
end
