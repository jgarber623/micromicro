# frozen_string_literal: true

module MicroMicro
  class Property
    PROPERTY_PARSERS_MAP = {
      "dt" => Parsers::DateTimePropertyParser,
      "e"  => Parsers::EmbeddedMarkupPropertyParser,
      "p"  => Parsers::PlainTextPropertyParser,
      "u"  => Parsers::UrlPropertyParser
    }.freeze

    private_constant :PROPERTY_PARSERS_MAP

    class PropertyNodeSearch
      attr_reader :node_set

      def initialize(document)
        @node_set = Nokogiri::XML::NodeSet.new(document, [])
      end

      def search(context)
        context.each { |node| search(node) } if context.is_a?(Nokogiri::XML::NodeSet)

        if context.is_a?(Nokogiri::XML::Element) && !Helpers.ignore_node?(context)
          node_set << context if Helpers.property_node?(context)

          search(context.element_children) unless Helpers.item_node?(context)
        end

        node_set
      end
    end

    private_constant :PropertyNodeSearch

    # The {MicroMicro::PropertiesCollection} to which this
    # {MicroMicro::Property} belongs.
    #
    # @return [MicroMicro::PropertiesCollection]
    attr_accessor :collection

    # This {MicroMicro::Property}'s +name+ value.
    #
    # @return [String]
    attr_reader :name

    # This {MicroMicro::Property}'s node.
    #
    # @return [Nokogiri::XML::Element]
    attr_reader :node

    # This {MicroMicro::Property}'s +prefix+ value.
    #
    # @return [String] One of +dt+, +e+, +p+, or +u+.
    attr_reader :prefix

    # Extract {MicroMicro::Property}s from a context.
    #
    # @param context [Nokogiri::XML::NodeSet, Nokogiri::XML::Element]
    # @return [Array<MicroMicro::Property>]
    def self.from_context(context)
      PropertyNodeSearch
        .new(context.document)
        .search(context)
        .flat_map do |node|
          Helpers.property_class_names_from(node).map { |token| new(node, token) }
        end
    end

    # Parse a node for property data.
    #
    # @param node [Nokogiri::XML::Element]
    # @param token [String] A hyphen-separated token representing a microformats2
    #   property value (e.g. +p-name+, +u-url+).
    def initialize(node, token)
      @node = node
      @prefix, @name = token.split("-", 2)
    end

    # Is this {MicroMicro::Property} a datetime property?
    #
    # @return [Boolean]
    def date_time_property?
      prefix == "dt"
    end

    # Is this {MicroMicro::Property} an embedded markup property?
    #
    # @return [Boolean]
    def embedded_markup_property?
      prefix == "e"
    end

    # Always return +false+ when asked if this {MicroMicro::Property} is an
    # implied property.
    #
    # @see MicroMicro::ImpliedProperty#implied?
    #
    # @return [Boolean]
    def implied?
      false
    end

    # @return [String]
    #
    # :nocov:
    def inspect
      "#<#{self.class}:#{format("%#0x", object_id)} " \
        "name: #{name.inspect}, " \
        "prefix: #{prefix.inspect}, " \
        "value: #{value.inspect}>"
    end
    # :nocov:

    # Parse this {MicroMicro::Property}'s node as a {MicroMicro::Item}, if
    # applicable.
    #
    # @return [MicroMicro::Item, nil]
    def item
      @item ||= Item.new(node) if item_node?
    end

    # Should this {MicroMicro::Property}'s node be parsed as a
    # {MicroMicro::Item}?
    #
    # @see MicroMicro::Helpers.item_node?
    #
    # @return [Boolean]
    def item_node?
      @item_node ||= Helpers.item_node?(node)
    end

    # Is this {MicroMicro::Property} a plain text property?
    #
    # @return [Boolean]
    def plain_text_property?
      prefix == "p"
    end

    # Is this {MicroMicro::Property} a url property?
    #
    # @return [Boolean]
    def url_property?
      prefix == "u"
    end

    # Return this {MicroMicro::Property}'s parsed value.
    #
    # @return [String, Hash]
    #
    # rubocop:disable Metrics
    def value
      @value ||=
        if item_node?
          hash = item.to_h

          return hash.merge(parser.value) if embedded_markup_property?

          p_property = item.properties.find_by(name: "name") if plain_text_property?
          u_property = item.properties.find_by(name: "url") if url_property?

          hash.merge(value: (p_property || u_property || parser).value)
        else
          parser.value
        end
    end
    # rubocop:enable Metrics

    # Returns +true+ if this {MicroMicro::Property}'s +value+ is anything other
    # than blank or +nil+.
    #
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
