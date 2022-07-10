# frozen_string_literal: true

module MicroMicro
  module Collections
    class RelationshipsCollection < BaseCollection
      # @see https://microformats.org/wiki/microformats2-parsing#parse_a_hyperlink_element_for_rel_microformats
      #
      # @return [Hash{Symbol => Array<String>}]
      def group_by_rel
        each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |member, hash|
          member.rels.each { |rel| hash[rel] << member.href }
        end.symbolize_keys.transform_values(&:uniq)
      end

      # @see https://microformats.org/wiki/microformats2-parsing#parse_a_hyperlink_element_for_rel_microformats
      #
      # @return [Hash{Symbol => Hash{Symbol => Array, String}}]
      def group_by_url
        group_by(&:href).symbolize_keys.transform_values { |relationships| relationships.first.to_h.slice!(:href) }
      end

      # @return [Array<String>]
      def rels
        @rels ||= map(&:rels).flatten.uniq.sort
      end

      # @return [Array<String>]
      def urls
        @urls ||= map(&:href).uniq.sort
      end
    end
  end
end
