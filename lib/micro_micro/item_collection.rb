module MicroMicro
  class ItemCollection
    def initialize(node_set, base_url)
      @node_set = node_set
      @base_url = base_url
    end

    def by_item
      @by_item ||= items.map { |item| OpenStruct.new(item.to_h) }
    end

    def items
      @items ||= self.class.root_nodes_from(@node_set).map { |node| Item.new(node, @base_url) }
    end

    def self.root_nodes_from(context)
      # Match all elements whose class attribute contains a token beginning with "h-"
      xpath_step = '*[contains(concat(" ", normalize-space(@class), " "), " h-")]'

      context.xpath(".//#{xpath_step}[not(ancestor::#{xpath_step})]")
    end
  end
end
