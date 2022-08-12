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

    # @param context [Nokogiri::XML::NodeSet, Nokogiri::XML::Element]
    # @return [Array<MicroMicro::Property>]
    def self.from_context(context)
      node_set_from(context).flat_map do |node|
        Helpers.property_class_names_from(node).map { |token| new(node, token) }
      end
    end

    # @param context [Nokogiri::XML::NodeSet, Nokogiri::XML::Element]
    # @param node_set [Nokogiri::XML::NodeSet]
    # @return [Nokogiri::XML::NodeSet]
    def self.node_set_from(context, node_set = Nokogiri::XML::NodeSet.new(context.document, []))
      context.each { |node| node_set_from(node, node_set) } if context.is_a?(Nokogiri::XML::NodeSet)

      if context.is_a?(Nokogiri::XML::Element) && !Helpers.ignore_node?(context)
        node_set << context if Helpers.property_node?(context)

        node_set_from(context.element_children, node_set) unless Helpers.item_node?(context)
      end

      node_set
    end

    # @param node [Nokogiri::XML::Element]
    # @param token [String]
    def initialize(node, token)
      @node = node
      @prefix, @name = token.split(/-/, 2)
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
      @item_node ||= Helpers.item_node?(node)
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
    # rubocop:disable Metrics
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
    # rubocop:enable Metrics

    # @return [Boolean]
    def value?
      value.present?
    end

    private

    def parser
      @parser ||= PROPERTY_PARSERS_MAP[prefix].new(self)
    end
  end
end
