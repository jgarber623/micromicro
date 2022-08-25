# frozen_string_literal: true

module MicroMicro
  module Collections
    class RelationshipsCollection < BaseCollection
      # Return a Hash of this collection's {MicroMicro::Relationship}s grouped
      # by their +rel+ attribute value.
      #
      # @see https://microformats.org/wiki/microformats2-parsing#parse_a_hyperlink_element_for_rel_microformats Parse a hyperlink element for rel microformats
      #
      # @return [Hash{Symbol => Array<String>}]
      def group_by_rel
        each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |member, hash|
          member.rels.each { |rel| hash[rel] << member.href }
        end.symbolize_keys.transform_values(&:uniq)
      end

      # Return a Hash of this collection's {MicroMicro::Relationship}s grouped
      # by their +href+ attribute value.
      #
      # @see https://microformats.org/wiki/microformats2-parsing#parse_a_hyperlink_element_for_rel_microformats Parse a hyperlink element for rel microformats
      #
      # @return [Hash{Symbol => Hash{Symbol => Array, String}}]
      def group_by_url
        group_by(&:href).symbolize_keys.transform_values { |relationships| relationships.first.to_h.slice!(:href) }
      end

      # Retrieve an Array of this collection's unique {MicroMicro::Relationship}
      # +rel+ attrivute values.
      #
      # @see MicroMicro::Relationship#rels
      #
      # @return [Array<String>]
      def rels
        @rels ||= flat_map(&:rels).uniq.sort
      end

      # Retrieve an Array of this collection's unique {MicroMicro::Relationship}
      # +href+ attribute values.
      #
      # @see MicroMicro::Relationship#urls
      #
      # @return [Array<String>]
      def urls
        @urls ||= map(&:href).uniq.sort
      end
    end
  end
end
