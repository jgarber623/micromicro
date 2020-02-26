module MicroMicro
  class RelationCollection
    def initialize(node_set, base_url)
      @node_set = node_set
      @base_url = base_url
    end

    def by_relation_type
      @by_relation_type ||= OpenStruct.new(by_relation_type_hash)
    end

    def by_relation_url
      @by_relation_url ||= OpenStruct.new(by_relation_url_hash)
    end

    private

    def by_relation_type_hash
      enum_with_obj(Array).each do |node, hash|
        node.attributes.rels.each { |rel| hash[rel] << node.url }
      end.transform_values(&:uniq)
    end

    def by_relation_url_hash
      enum_with_obj(Hash).each do |node, hash|
        hash[node.url] = node.attributes unless hash.key?(node.url)
      end
    end

    def enum_with_obj(obj_class)
      relations.each_with_object(Hash.new { |hash, key| hash[key] = obj_class.new })
    end

    def relations
      @relations ||= @node_set.map { |node| Relation.new(node, @base_url) }
    end
  end
end
