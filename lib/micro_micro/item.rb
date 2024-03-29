# frozen_string_literal: true

module MicroMicro
  class Item
    class ItemNodeSearch
      attr_reader :node_set

      def initialize(document)
        @node_set = Nokogiri::XML::NodeSet.new(document, [])
      end

      # rubocop:disable Metrics
      def search(context)
        context.each { |node| search(node) } if context.is_a?(Nokogiri::XML::NodeSet)

        if context.is_a?(Nokogiri::XML::Element) && !Helpers.ignore_node?(context)
          if Helpers.item_node?(context)
            node_set << context unless Helpers.item_nodes?(context.ancestors) && Helpers.property_node?(context)
          else
            search(context.element_children)
          end
        end

        node_set
      end
      # rubocop:enable Metrics
    end

    private_constant :ItemNodeSearch

    # The {MicroMicro::ItemsCollection} to which this {MicroMicro::Item} belongs.
    #
    # @return [MicroMicro::PropertiesCollection]
    attr_accessor :collection

    # Extract {MicroMicro::Item}s from a context.
    #
    # @param context [Nokogiri::HTML5::Document, Nokogiri::XML::NodeSet, Nokogiri::XML::Element]
    # @return [Array<MicroMicro::Item>]
    def self.from_context(context)
      ItemNodeSearch
        .new(context.document)
        .search(context)
        .map { |node| new(node) }
    end

    # Parse a node for microformats2-encoded data.
    #
    # @param node [Nokogiri::XML::Element]
    # @return [MicroMicro::Item]
    def initialize(node)
      @node = node

      properties << implied_name if implied_name?
      properties << implied_photo if implied_photo?
      properties << implied_url if implied_url?
    end

    # A collection of child {MicroMicro::Item}s parsed from the node.
    #
    # @see https://microformats.org/wiki/microformats2-parsing#parse_an_element_for_class_microformats
    #   microformats.org: microformats2 parsing specification § Parse an element for class microformats
    #
    # @return [MicroMicro::Collections::ItemsCollection]
    def children
      @children ||= Collections::ItemsCollection.new(self.class.from_context(node.element_children))
    end

    # Does this {MicroMicro::Item} contain any child {MicroMicro::Item}s?
    #
    # @return [Boolean]
    def children?
      children.any?
    end

    # The value of the node's +id+ attribute, if present.
    #
    # @return [String, nil]
    def id
      @id ||= node["id"]&.strip
    end

    # Does this {MicroMicro::Item} have an +id+ attribute value?
    #
    # @return [Boolean]
    def id?
      id.present?
    end

    # @return [String]
    #
    # :nocov:
    def inspect
      "#<#{self.class}:#{format("%#0x", object_id)} " \
        "types: #{types.inspect}, " \
        "properties: #{properties.count}, " \
        "children: #{children.count}>"
    end
    # :nocov:

    # A collection of {MicroMicro::Property}s parsed from the node.
    #
    # @return [MicroMicro::Collections::PropertiesCollection]
    def properties
      @properties ||= Collections::PropertiesCollection.new(Property.from_context(node.element_children))
    end

    # Return the parsed {MicroMicro::Item} as a Hash.
    #
    # @see https://microformats.org/wiki/microformats2-parsing#parse_an_element_for_class_microformats
    #   microformats.org: microformats2 parsing specification § Parse an element for class microformats
    #
    # @see MicroMicro::Item#children
    # @see MicroMicro::Item#id
    # @see MicroMicro::Item#properties
    # @see MicroMicro::Item#types
    # @see MicroMicro::Collections::PropertiesCollection#to_h
    #
    # @return [Hash]
    def to_h
      hash = {
        type: types,
        properties: properties.to_h
      }

      hash[:id] = id if id?
      hash[:children] = children.to_a if children?

      hash
    end

    # An Array of root class names parsed from the node's +class+ attribute.
    #
    # @return [Array<String>]
    def types
      @types ||= Helpers.root_class_names_from(node)
    end

    private

    # @return [Nokogiri::XML::Element]
    attr_reader :node

    # @return [MicroMicro::ImpliedProperty]
    def implied_name
      @implied_name ||= ImpliedProperty.new(node, "p-name")
    end

    # @return [Boolean]
    def implied_name?
      imply_name? && implied_name.value?
    end

    # @return [MicroMicro::ImpliedProperty]
    def implied_photo
      @implied_photo ||= ImpliedProperty.new(node, "u-photo")
    end

    # @return [Boolean]
    def implied_photo?
      imply_photo? && implied_photo.value?
    end

    # @return [MicroMicro::ImpliedProperty]
    def implied_url
      @implied_url ||= ImpliedProperty.new(node, "u-url")
    end

    # @return [Boolean]
    def implied_url?
      imply_url? && implied_url.value?
    end

    # @return [Boolean]
    def imply_name?
      properties.names.none?("name") &&
        properties.none?(&:embedded_markup_property?) &&
        properties.none?(&:plain_text_property?) &&
        !nested_items?
    end

    # @return [Boolean]
    def imply_photo?
      properties.names.none?("photo") &&
        properties.reject(&:implied?).none?(&:url_property?) &&
        !nested_items?
    end

    # @return [Boolean]
    def imply_url?
      properties.names.none?("url") &&
        properties.reject(&:implied?).none?(&:url_property?) &&
        !nested_items?
    end

    # @return [Boolean]
    def nested_items?
      @nested_items ||= properties.find(&:item_node?) || children?
    end
  end
end
