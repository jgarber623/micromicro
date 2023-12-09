# frozen_string_literal: true

module MicroMicro
  module Helpers
    IGNORED_NODE_NAMES = %w[script style template].freeze

    private_constant :IGNORED_NODE_NAMES

    # @param node [Nokogiri::XML::Element]
    # @param attributes_map [Hash{String => Array}]
    # @return [String, nil]
    def self.attribute_value_from(node, attributes_map)
      attributes_map
        .filter_map { |attribute, names| node[attribute] if names.include?(node.name) && node[attribute] }
        .first
    end

    # @param node [Nokogiri::XML::Element]
    # @return [Boolean]
    def self.ignore_node?(node)
      IGNORED_NODE_NAMES.include?(node.name)
    end

    # @param nodes [Nokogiri::XML::NodeSet]
    # @return [Boolean]
    def self.ignore_nodes?(nodes)
      (nodes.map(&:name) & IGNORED_NODE_NAMES).any?
    end

    # @param node [Nokogiri::XML::Element]
    # @return [Boolean]
    def self.item_node?(node)
      root_class_names_from(node).any?
    end

    # @param nodes [Nokogiri::XML::NodeSet]
    # @return [Boolean]
    def self.item_nodes?(nodes)
      nodes.filter_map { |node| item_node?(node) }.any?
    end

    # @param node [Nokogiri::XML::Element]
    # @return [Array<String>]
    def self.property_class_names_from(node)
      node.classes.grep(/^(?:dt|e|p|u)(?:-[0-9a-z]+)?(?:-[a-z]+)+$/).uniq
    end

    # @param node [Nokogiri::XML::Element]
    # @return [Boolean]
    def self.property_node?(node)
      property_class_names_from(node).any?
    end

    # @param node [Nokogiri::XML::Element]
    # @return [Array<String>]
    def self.root_class_names_from(node)
      Set[*node.classes.grep(/^h(?:-[0-9a-z]+)?(?:-[a-z]+)+$/)].to_a.sort
    end

    # @see https://microformats.org/wiki/microformats2-parsing#parse_an_element_for_properties
    #   microformats.org: microformats2 parsing specification § Parse an element for properties
    # @see https://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
    #   microformats.org: microformats2 parsing specification § Parsing for implied properties
    #
    # @param context [Nokogiri::HTML5::Document, Nokogiri::XML::NodeSet, Nokogiri::XML::Element]
    # @yield [context]
    # @return [String]
    def self.text_content_from(context)
      context.css(*IGNORED_NODE_NAMES).unlink

      yield(context) if block_given?

      context.text.strip
    end

    # @see https://microformats.org/wiki/value-class-pattern#Basic_Parsing
    #   microformats.org: Value Class Pattern § Basic Parsing
    #
    # @param node [Nokogiri::XML::Element]
    # @return [Boolean]
    def self.value_class_node?(node)
      node.classes.include?("value")
    end

    # @see https://microformats.org/wiki/value-class-pattern#Parsing_value_from_a_title_attribute
    #   microformats.org: Value Class Pattern § Parsing value from a title attribute
    #
    # @param node [Nokogiri::XML::Element]
    # @return [Boolean]
    def self.value_title_node?(node)
      node.classes.include?("value-title")
    end
  end
end
