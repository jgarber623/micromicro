module MicroMicro
  class Item
    attr_accessor :value

    # @param node [Nokogiri::XML::Element]
    def initialize(node)
      @node = node

      properties << implied_name if implied_name?
      properties << implied_photo if implied_photo?
      properties << implied_url if implied_url?
    end

    # @return [MicroMicro::Collections::ItemsCollection]
    def children
      @children ||= Collections::ItemsCollection.new(Item.nodes_from(node.element_children))
    end

    # @return [String, nil]
    def id
      @id ||= node['id']&.strip
    end

    # @return [MicroMicro::Collections::PropertiesCollection]
    def properties
      @properties ||= Collections::PropertiesCollection.new(Property.nodes_from(node.element_children), node)
    end

    # @see microformats2 Parsing Specification section 1.2
    # @see http://microformats.org/wiki/microformats2-parsing#parse_an_element_for_class_microformats
    #
    # @return [Hash]
    def to_h
      hash = {
        type: types,
        properties: properties.to_h
      }

      hash[:id] = id if id.present?
      hash[:children] = children.to_a if children.any?
      hash[:value] = value if value.present?

      hash
    end

    # @return [Array<String>]
    def types
      @types ||= self.class.types_from(node)
    end

    # @param node [Nokogiri::XML::Element]
    # @return [Boolean]
    def self.item_node?(node)
      types_from(node).any?
    end

    # @param context [Nokogiri::HTML::Document, Nokogiri::XML::NodeSet, Nokogiri::XML::Element]
    # @param node_set [Nokogiri::XML::NodeSet]
    # @return [Nokogiri::XML::NodeSet]
    def self.nodes_from(context, node_set = Nokogiri::XML::NodeSet.new(context.document, []))
      return nodes_from(context.element_children, node_set) if context.is_a?(Nokogiri::HTML::Document)

      context.each { |node| nodes_from(node, node_set) } if context.is_a?(Nokogiri::XML::NodeSet)

      if context.is_a?(Nokogiri::XML::Element) && !Document.ignore_node?(context)
        if item_node?(context)
          node_set << context unless Property.property_node?(context)
        else
          nodes_from(context.element_children, node_set)
        end
      end

      node_set
    end

    # @param node [Nokogiri::XML::Element]
    # @return [Array<String>]
    #
    # @example
    #   node = Nokogiri::HTML('<div class="h-card">Jason Garber</div>').at_css('div')
    #   MicroMicro::Item.types_from(node) #=> ['h-card']
    def self.types_from(node)
      node.classes.select { |token| token.match?(/^h(?:\-[0-9a-z]+)?(?:\-[a-z]+)+$/) }.uniq.sort
    end

    private

    attr_reader :node

    # @return [MicroMicro::Property]
    def implied_name
      @implied_name ||= Property.new(node, name: 'name', prefix: 'p', implied: true)
    end

    # @return [Boolean]
    def implied_name?
      imply_name? && implied_name.value?
    end

    # @return [MicroMicro::Property]
    def implied_photo
      @implied_photo ||= Property.new(node, name: 'photo', prefix: 'u', implied: true)
    end

    # @return [Boolean]
    def implied_photo?
      imply_photo? && implied_photo.value?
    end

    # @return [MicroMicro::Property]
    def implied_url
      @implied_url ||= Property.new(node, name: 'url', prefix: 'u', implied: true)
    end

    # @return [Boolean]
    def implied_url?
      imply_url? && implied_url.value?
    end

    # @return [Boolean]
    def imply_name?
      !properties.find_by(:name, 'name') && properties.find_all_by(:prefix, 'p', 'e').none? && !nested_items?
    end

    # @return [Boolean]
    def imply_photo?
      !properties.find_by(:name, 'photo') && properties.find_all_by(:prefix, 'u').reject(&:implied?).none? && !nested_items?
    end

    # @return [Boolean]
    def imply_url?
      !properties.find_by(:name, 'url') && properties.find_all_by(:prefix, 'u').reject(&:implied?).none? && !nested_items?
    end

    # @return [Boolean]
    def nested_items?
      @nested_items ||= properties.find_by(:item_node?, true) || children.any?
    end
  end
end
