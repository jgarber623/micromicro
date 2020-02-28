module MicroMicro
  module Collections
    class RelationsCollection < BaseCollection
      def to_h
        @to_h ||= begin
          each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |member, hash|
            member.attributes.rels.each { |rel| hash[rel.to_sym] << member.url }
          end.transform_values(&:uniq)
        end
      end

      private

      def members
        @members ||= node_set.map { |node| Relation.new(node, base_url) }
      end
    end
  end
end
