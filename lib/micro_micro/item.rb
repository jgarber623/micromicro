# frozen_string_literal: true

module MicroMicro
  class Item
    include Collectible

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

      if context.is_a?(Nokogiri::XML::Element) && !Helpers.ignore_node?(context)
        if Helpers.item_node?(context)
          node_set << context unless Helpers.property_node?(context)
        else
          nodes_from(context.element_children, node_set)
        end
      end

      node_set
    end

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
    # @see https://microformats.org/wiki/microformats2-parsing#parse_an_element_for_class_microformats
    #
    # @return [MicroMicro::Collections::ItemsCollection]
    def children
      @children ||= Collections::ItemsCollection.new(self.class.items_from(node.element_children))
    end

    # The value of the node's `id` attribute, if present.
    #
    # @return [String, nil]
    def id
      @id ||= node['id']&.strip
    end

    # :nocov:
    # @return [String]
    def inspect
      "#<#{self.class}:#{format('%#0x', object_id)} " \
        "types: #{types.inspect}, " \
        "properties: #{properties.count}, " \
        "children: #{children.count}>"
    end
    # :nocov:

    # A collection of plain text properties parsed from the node.
    #
    # @return [MicroMicro::Collections::PropertiesCollection]
    def plain_text_properties
      @plain_text_properties ||= properties.plain_text_properties
    end

    # A collection of properties parsed from the node.
    #
    # @return [MicroMicro::Collections::PropertiesCollection]
    def properties
      @properties ||= Collections::PropertiesCollection.new(Property.properties_from(node.element_children))
    end

    # Return the parsed item as a Hash.
    #
    # @see https://microformats.org/wiki/microformats2-parsing#parse_an_element_for_class_microformats
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
      @types ||= Helpers.root_class_names_from(node)
    end

    # A collection of url properties parsed from the node.
    #
    # @return [MicroMicro::Collections::PropertiesCollection]
    def url_properties
      @url_properties ||= properties.url_properties
    end

    private

    attr_reader :node

    # @return [MicroMicro::ImpliedProperty]
    def implied_name
      @implied_name ||= ImpliedProperty.new(node, 'p-name')
    end

    # @return [Boolean]
    def implied_name?
      imply_name? && implied_name.value?
    end

    # @return [MicroMicro::ImpliedProperty]
    def implied_photo
      @implied_photo ||= ImpliedProperty.new(node, 'u-photo')
    end

    # @return [Boolean]
    def implied_photo?
      imply_photo? && implied_photo.value?
    end

    # @return [MicroMicro::ImpliedProperty]
    def implied_url
      @implied_url ||= ImpliedProperty.new(node, 'u-url')
    end

    # @return [Boolean]
    def implied_url?
      imply_url? && implied_url.value?
    end

    # @return [Boolean]
    def imply_name?
      properties.names.none?('name') &&
        properties.none?(&:embedded_markup_property?) &&
        properties.none?(&:plain_text_property?) &&
        !nested_items?
    end

    # @return [Boolean]
    def imply_photo?
      properties.names.none?('photo') &&
        properties.reject(&:implied?).none?(&:url_property?) &&
        !nested_items?
    end

    # @return [Boolean]
    def imply_url?
      properties.names.none?('url') &&
        properties.reject(&:implied?).none?(&:url_property?) &&
        !nested_items?
    end

    # @return [Boolean]
    def nested_items?
      @nested_items ||= properties.find(&:item_node?) || children.any?
    end
  end
end
