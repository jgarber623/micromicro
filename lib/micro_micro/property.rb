# frozen_string_literal: true

module MicroMicro
  class Property
    include Collectible

    PROPERTY_PARSERS_MAP = {
      'dt' => Parsers::DateTimePropertyParser,
      'e'  => Parsers::EmbeddedMarkupPropertyParser,
      'p'  => Parsers::PlainTextPropertyParser,
      'u'  => Parsers::UrlPropertyParser
    }.freeze

    attr_reader :name, :node, :prefix

    # @param node [Nokogiri::XML::Element]
    # @param name [String]
    # @param prefix [String<dt, e, p, u>]
    def initialize(node, name:, prefix:)
      @node = node
      @name = name
      @prefix = prefix
    end

    # @return [Boolean]
    def date_time_property?
      prefix == 'dt'
    end

    # @return [Boolean]
    def embedded_markup_property?
      prefix == 'e'
    end

    # @return [Boolean]
    def implied?
      false
    end

    # :nocov:
    # @return [String]
    def inspect
      "#<#{self.class}:#{format('%#0x', object_id)} " \
        "name: #{name.inspect}, " \
        "prefix: #{prefix.inspect}, " \
        "value: #{value.inspect}>"
    end
    # :nocov:

    # @return [MicroMicro::Item, nil]
    def item
      @item ||= Item.new(node) if item_node?
    end

    # @return [Boolean]
    def item_node?
      @item_node ||= Item.item_node?(node)
    end

    # @return [Boolean]
    def plain_text_property?
      prefix == 'p'
    end

    # @return [Boolean]
    def url_property?
      prefix == 'u'
    end

    # @return [String, Hash]
    def value
      @value ||=
        if item_node?
          hash = item.to_h

          return hash.merge(parser.value) if embedded_markup_property?

          p_property = item.properties.find { |property| property.name == 'name' } if plain_text_property?
          u_property = item.properties.find { |property| property.name == 'url' } if url_property?

          hash.merge(value: (p_property || u_property || parser).value)
        else
          parser.value
        end
    end

    # @return [Boolean]
    def value?
      value.present?
    end

    # @param context [Nokogiri::XML::NodeSet, Nokogiri::XML::Element]
    # @param node_set [Nokogiri::XML::NodeSet]
    # @return [Nokogiri::XML::NodeSet]
    def self.nodes_from(context, node_set = Nokogiri::XML::NodeSet.new(context.document, []))
      context.each { |node| nodes_from(node, node_set) } if context.is_a?(Nokogiri::XML::NodeSet)

      if context.is_a?(Nokogiri::XML::Element) && !Document.ignore_node?(context)
        node_set << context if property_node?(context)

        nodes_from(context.element_children, node_set) unless Item.item_node?(context)
      end

      node_set
    end

    # @param context [Nokogiri::XML::NodeSet, Nokogiri::XML::Element]
    # @return [Array<MicroMicro::Property>]
    def self.properties_from(context)
      nodes_from(context).map do |node|
        types_from(node).map { |prefix, name| new(node, name: name, prefix: prefix) }
      end.flatten
    end

    # @param node [Nokogiri::XML::Element]
    # @return [Boolean]
    def self.property_node?(node)
      types_from(node).any?
    end

    # @param node [Nokogiri::XML::Element]
    # @return [Array<Array(String, String)>]
    #
    # @example
    #   node = Nokogiri::HTML('<a href="https://sixtwothree.org" class="p-name u-url">Jason Garber</a>').at_css('a')
    #   MicroMicro::Property.types_from(node) #=> [['p', 'name'], ['u', 'url']]
    def self.types_from(node)
      node.classes.filter_map do |token|
        token.split(/-/, 2) if token.match?(/^(?:dt|e|p|u)(?:-[0-9a-z]+)?(?:-[a-z]+)+$/)
      end.uniq
    end

    private

    def parser
      @parser ||= PROPERTY_PARSERS_MAP[prefix].new(self)
    end
  end
end
