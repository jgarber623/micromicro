module MicroMicro
  class Item
    def initialize(node, base_url)
      @node = node
      @base_url = base_url
    end

    def children
      @children ||= [] # ItemCollection.new(ItemCollection.root_nodes_from(node.children), base_url).by_item
    end

    def id
      @id ||= node['id']&.strip
    end

    def properties
      @properties ||= {}
    end

    def to_h
      @to_h ||= begin
        {
          type: types,
          properties: properties,
          id: id,
          children: children
        }.select { |_, value| value.present? }
      end
    end

    def types
      @types ||= self.class.root_class_names_from(node['class'])
    end

    def self.root_class_names_from(value)
      value.scan(/h\-[a-z\-]+/).uniq.sort
    end

    private

    attr_reader :base_url, :node
  end
end
