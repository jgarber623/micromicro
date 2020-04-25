module MicroMicro
  module Collections
    class RelationsCollection
      include Collectible

      # @param node_set [Nokogiri::XML::NodeSet]
      def initialize(node_set)
        @node_set = node_set
      end

      # @return [Array<MicroMicro::Relation>]
      def members
        @members ||= node_set.map { |node| Relation.new(node) }
      end

      # @return [Hash{Symbole => Hash{Symbol => Array, String}}]
      def group_by_url
        members.group_by(&:url).symbolize_keys.transform_values { |relations| relations.first.to_h.slice!(:url) }
      end

      # @return [Hash{Symbol => Array<String>}]
      def group_by_rel
        each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |member, hash|
          member.rels.each { |rel| hash[rel] << member.url }
        end.symbolize_keys.transform_values(&:uniq)
      end

      private

      attr_reader :node_set
    end
  end
end
