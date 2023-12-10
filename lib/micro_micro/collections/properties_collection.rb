# frozen_string_literal: true

module MicroMicro
  module Collections
    class PropertiesCollection < BaseCollection
      class PropertiesCollectionSearch
        def search(properties, **args, &block)
          properties.select { |property| property_matches_conditions?(property, **args, &block) }
        end

        private

        def property_matches_conditions?(property, **args)
          return yield(property) if args.none?

          args.all? { |key, value| (Array(property.public_send(key.to_sym)) & Array(value)).any? }
        end
      end

      private_constant :PropertiesCollectionSearch

      # Return the first {MicroMicro::Property} from a search.
      #
      # @see #where
      #
      # @param (see #where)
      # @yieldparam (see #where))
      # @return [MicroMicro::Property, nil]
      def find_by(**args, &block)
        where(**args, &block).first
      end

      # Retrieve an Array of this collection's unique {MicroMicro::Property}
      # names.
      #
      # @see MicroMicro::Property#name
      #
      # @return [Array<String>]
      def names
        @names ||= Set[*map(&:name)].to_a.sort
      end

      # A collection of plain text {MicroMicro::Property}s parsed from the node.
      #
      # @see MicroMicro::Property#plain_text_property?
      #
      # @return [MicroMicro::Collections::PropertiesCollection]
      def plain_text_properties
        @plain_text_properties ||= self.class.new(select(&:plain_text_property?))
      end

      # Does this {MicroMicro::Collections::PropertiesCollection} include any
      # plain text {MicroMicro::Property}s?
      #
      # @return [Boolean]
      def plain_text_properties?
        plain_text_properties.any?
      end

      # Return a Hash of this collection's {MicroMicro::Property}s as Arrays.
      #
      # @see MicroMicro::Property#name
      # @see MicroMicro::Property#value
      #
      # @return [Hash{Symbol => Array<String, Hash>}]
      def to_h
        group_by(&:name).transform_keys(&:to_sym).deep_transform_values(&:value)
      end

      # A collection of url {MicroMicro::Property}s parsed from the node.
      #
      # @see MicroMicro::Property#url_property?
      #
      # @return [MicroMicro::Collections::PropertiesCollection]
      def url_properties
        @url_properties ||= self.class.new(select(&:url_property?))
      end

      # Does this {MicroMicro::Collections::PropertiesCollection} include any
      # url {MicroMicro::Property}s?
      #
      # @return [Boolean]
      def url_properties?
        url_properties.any?
      end

      # Return an Array of this collection's unique {MicroMicro::Property}
      # values.
      #
      # @see MicroMicro::Property#value
      #
      # @return [Array<String, Hash>]
      def values
        @values ||= Set[*map(&:value)].to_a
      end

      # Search this collection for {MicroMicro::Property}s matching the given
      # conditions.
      #
      # If a Hash is supplied, the returned collection will include
      # {MicroMicro::Property}s matching _all_ conditions. Keys must be Symbols
      # matching an instance method on {MicroMicro::Property} and values may be
      # either a String or an Array of Strings.
      #
      # @example Search using a Hash with a String value
      #   MicroMicro.parse(markup, url).properties.where(name: "url")
      #
      # @example Search using a Hash with an Array value
      #   MicroMicro.parse(markup, url).properties.where(name: ["name", "url"])
      #
      # When passing a block, each {MicroMicro::Property} in this collection
      # is yielded to the block and the returned collection will include
      # {MicroMicro::Property}s that cause the block to return a value other
      # than +false+ or +nil+.
      #
      # @example Search using a block
      #   MicroMicro.parse(markup, url).properties.where do |property|
      #     property.value.is_a?(Hash)
      #   end
      #
      # @param args [Hash{Symbol => String, Array<String>}]
      # @yieldparam property [MicroMicro::Property]
      # @return [MicroMicro::Collections::PropertiesCollection]
      def where(**args, &block)
        return self if args.none? && !block

        self.class.new(PropertiesCollectionSearch.new.search(self, **args, &block))
      end
    end
  end
end
