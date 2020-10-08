module MicroMicro
  class Item
    include Collectible

    # Parse a node for microformats2-encoded data.
    #
    # @param node [Nokogiri::XML::Element]
    def initialize(node)
      @node = node

      properties << implied_name if implied_name?
      properties << implied_photo if implied_photo?
      properties << implied_url if implied_url?
    end

    # A collection of child items parsed from the node.
    #
    # @see http://microformats.org/wiki/microformats2-parsing#parse_an_element_for_class_microformats
    #
    # @return [MicroMicro::Collections::ItemsCollection]
    def children
      @children ||= Collections::ItemsCollection.new(Item.items_from(node.element_children))
    end

    # The value of the node's `id` attribute, if present.
    #
    # @return [String, nil]
    def id
      @id ||= node['id']&.strip
    end

    # @return [String]
    def inspect
      format(%(#<#{self.class.name}:%#0x types: #{types.inspect}, properties: #{properties.count}, children: #{children.count}>), object_id)
    end

    # @return [MicroMicro::Collections::PropertiesCollection]
    def properties
      @properties ||= Collections::PropertiesCollection.new(Property.properties_from(node.element_children))
    end

    # Return the parsed item as a Hash.
    #
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

      hash
    end

    # An array of root class names parsed from the node's `class` attribute.
    #
    # @return [Array<String>]
    def types
      @types ||= self.class.types_from(node)
    end

    # Does this node's `class` attribute contain root class names?
    #
    # @param node [Nokogiri::XML::Element]
    # @return [Boolean]
    def self.item_node?(node)
      types_from(node).any?
    end

    # Extract items from a context.
    #
    # @param context [Nokogiri::HTML::Document, Nokogiri::XML::NodeSet, Nokogiri::XML::Element]
    # @return [Array<MicroMicro::Item>]
    def self.items_from(context)
      nodes_from(context).map { |node| new(node) }
    end

    # Extract item nodes from a context.
    #
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

    # Extract root class names from a node.
    #
    #   node = Nokogiri::HTML('<div class="h-card">Jason Garber</div>').at_css('div')
    #   MicroMicro::Item.types_from(node) #=> ['h-card']
    #
    # @param node [Nokogiri::XML::Element]
    # @return [Array<String>]
    def self.types_from(node)
      node.classes.select { |token| token.match?(/^h(?:-[0-9a-z]+)?(?:-[a-z]+)+$/) }.uniq.sort
    end

    private

    attr_reader :node

    # @return [MicroMicro::ImpliedProperty]
    def implied_name
      @implied_name ||= ImpliedProperty.new(node, name: 'name', prefix: 'p')
    end

    # @return [Boolean]
    def implied_name?
      imply_name? && implied_name.value?
    end

    # @return [MicroMicro::ImpliedProperty]
    def implied_photo
      @implied_photo ||= ImpliedProperty.new(node, name: 'photo', prefix: 'u')
    end

    # @return [Boolean]
    def implied_photo?
      imply_photo? && implied_photo.value?
    end

    # @return [MicroMicro::ImpliedProperty]
    def implied_url
      @implied_url ||= ImpliedProperty.new(node, name: 'url', prefix: 'u')
    end

    # @return [Boolean]
    def implied_url?
      imply_url? && implied_url.value?
    end

    # @return [Boolean]
    def imply_name?
      properties.none? { |prop| prop.name == 'name' } && properties.none? { |prop| %w[e p].include?(prop.prefix) } && !nested_items?
    end

    # @return [Boolean]
    def imply_photo?
      properties.none? { |prop| prop.name == 'photo' } && properties.reject(&:implied?).none? { |prop| prop.prefix == 'u' } && !nested_items?
    end

    # @return [Boolean]
    def imply_url?
      properties.none? { |prop| prop.name == 'url' } && properties.reject(&:implied?).none? { |prop| prop.prefix == 'u' } && !nested_items?
    end

    # @return [Boolean]
    def nested_items?
      @nested_items ||= properties.find(&:item_node?) || children.any?
    end
  end
end
