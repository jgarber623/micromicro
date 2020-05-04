module MicroMicro
  module Collections
    class RelationsCollection
      include Collectible

      # @param members [Array<MicroMicro::Relation>]
      def initialize(members = [])
        @members = members
      end

      # @see microformats2 Parsing Specification section 1.4
      # @see http://microformats.org/wiki/microformats2-parsing#parse_a_hyperlink_element_for_rel_microformats
      #
      # @return [Hash{Symbole => Hash{Symbol => Array, String}}]
      def group_by_url
        group_by(&:href).symbolize_keys.transform_values { |relations| relations.first.to_h.slice!(:href) }
      end

      # @see microformats2 Parsing Specification section 1.4
      # @see http://microformats.org/wiki/microformats2-parsing#parse_a_hyperlink_element_for_rel_microformats
      #
      # @return [Hash{Symbol => Array<String>}]
      def group_by_rel
        each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |member, hash|
          member.rels.each { |rel| hash[rel] << member.href }
        end.symbolize_keys.transform_values(&:uniq)
      end

      private

      attr_reader :members
    end
  end
end
