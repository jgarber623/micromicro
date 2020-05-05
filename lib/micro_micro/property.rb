module MicroMicro
  class Property
    PROPERTY_PARSERS_MAP = {
      'dt' => Parsers::DateTimePropertyParser,
      'e'  => Parsers::EmbeddedMarkupPropertyParser,
      'p'  => Parsers::PlainTextPropertyParser,
      'u'  => Parsers::UrlPropertyParser
    }.freeze

    attr_accessor :collection
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
    def implied?
      false
    end

    # @return [Boolean]
    def item_node?
      @item_node ||= Item.item_node?(node)
    end

    # @return [String, Hash, MicroMicro::Item]
    def value
      @value ||= begin
        return parser.value unless item_node?

        item.value = item_value

        item
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
      node.classes.select { |token| token.match?(/^(?:dt|e|p|u)(?:\-[0-9a-z]+)?(?:\-[a-z]+)+$/) }.map { |token| token.split(/\-/, 2) }.uniq
    end

    private

    # @return [MicroMicro::Item, nil]
    def item
      @item ||= Item.new(node) if item_node?
    end

    # @reutrn [String, nil]
    def item_value
      return unless item_node?

      obj_by_prefix = case prefix
                      when 'e' then item
                      when 'p' then item.properties.find_by(:name, 'name')
                      when 'u' then item.properties.find_by(:name, 'url')
                      end

      (obj_by_prefix || parser).value
    end

    def parser
      @parser ||= PROPERTY_PARSERS_MAP[prefix].new(self)
    end
  end
end
