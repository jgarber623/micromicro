module MicroMicro
  module Collections
    class RelationUrlsCollection < BaseCollection
      def to_h
        # @to_h ||= group_by(&:url).to_h.transform_values { |value| value.first.attributes.to_h }
        @to_h ||= group_by(&:url).map { |url, values| [url.to_sym, values.first.attributes.to_h] }.to_h
      end

      private

      def members
        @members ||= node_set.map { |node| Relation.new(node, base_url) }
      end
    end
  end
end
