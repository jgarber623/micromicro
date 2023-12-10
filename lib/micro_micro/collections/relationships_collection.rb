# frozen_string_literal: true

module MicroMicro
  module Collections
    class RelationshipsCollection < BaseCollection
      class RelationshipsCollectionSearch
        def search(relationships, **args, &block)
          relationships.select { |relationship| relationship_matches_conditions?(relationship, **args, &block) }
        end

        private

        def relationship_matches_conditions?(relationship, **args)
          return yield(relationship) if args.none?

          args.all? { |key, value| (Array(relationship.public_send(key.to_sym)) & Array(value)).any? }
        end
      end

      private_constant :RelationshipsCollectionSearch

      # Return the first {MicroMicro::Relationship} from a search.
      #
      # @see #where
      #
      # @param (see #where)
      # @yieldparam (see #where))
      # @return [MicroMicro::Relationship, nil]
      def find_by(**args, &block)
        where(**args, &block).first
      end

      # Return a Hash of this collection's {MicroMicro::Relationship}s grouped
      # by their +rel+ attribute value.
      #
      # @see https://microformats.org/wiki/microformats2-parsing#parse_a_hyperlink_element_for_rel_microformats
      #   microformats.org: microformats2 parsing specification § Parse a hyperlink element for rel microformats
      #
      # @return [Hash{Symbol => Array<String>}]
      def group_by_rel
        obj = Hash.new { |hash, key| hash[key] = Set.new }

        each_with_object(obj) { |member, hash| member.rels.each { |rel| hash[rel.to_sym] << member.href } }
          .transform_values(&:to_a)
      end

      # Return a Hash of this collection's {MicroMicro::Relationship}s grouped
      # by their +href+ attribute value.
      #
      # @see https://microformats.org/wiki/microformats2-parsing#parse_a_hyperlink_element_for_rel_microformats
      #   microformats.org: microformats2 parsing specification § Parse a hyperlink element for rel microformats
      #
      # @return [Hash{Symbol => Hash{Symbol => Array, String}}]
      def group_by_url
        group_by(&:href).to_h { |k, v| [k.to_sym, v.first.to_h.except(:href)] }
      end

      # Retrieve an Array of this collection's unique {MicroMicro::Relationship}
      # +rel+ attrivute values.
      #
      # @see MicroMicro::Relationship#rels
      #
      # @return [Array<String>]
      def rels
        @rels ||= Set[*flat_map(&:rels)].to_a.sort
      end

      # Retrieve an Array of this collection's unique {MicroMicro::Relationship}
      # +href+ attribute values.
      #
      # @see MicroMicro::Relationship#urls
      #
      # @return [Array<String>]
      def urls
        @urls ||= Set[*map(&:href)].to_a.sort
      end

      # Search this collection for {MicroMicro::Relationship}s matching the
      # given conditions.
      #
      # If a Hash is supplied, the returned collection will include
      # {MicroMicro::Relationship}s matching _all_ conditions. Keys must be
      # Symbols matching an instance method on {MicroMicro::Relationship} and
      # values may be either a String or an Array of Strings.
      #
      # @example Search using a Hash with a String value
      #   MicroMicro.parse(markup, url).relationships.where(rels: "webmention")
      #
      # @example Search using a Hash with an Array value
      #   MicroMicro.parse(markup, url).relationships.where(rels: ["me", "webmention"])
      #
      # When passing a block, each {MicroMicro::Relationship} in this collection
      # is yielded to the block and the returned collection will include
      # {MicroMicro::Relationship}s that cause the block to return a value other
      # than +false+ or +nil+.
      #
      # @example Search using a block
      #   MicroMicro.parse(markup, url).relationships.where do |relationship|
      #     relationship.href.match?(%r{https://webmention.io/.+})
      #   end
      #
      # @param args [Hash{Symbol => String, Array<String>}]
      # @yieldparam relationship [MicroMicro::Relationship]
      # @return [MicroMicro::Collections::RelationshipsCollection]
      def where(**args, &block)
        return self if args.none? && !block

        self.class.new(RelationshipsCollectionSearch.new.search(self, **args, &block))
      end
    end
  end
end
