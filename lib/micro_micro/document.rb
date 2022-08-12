# frozen_string_literal: true

module MicroMicro
  class Document
    # Parse a string of HTML for microformats2-encoded data.
    #
    #   MicroMicro::Document.new('<a href="/" class="h-card" rel="me">Jason Garber</a>', 'https://sixtwothree.org')
    #
    # Or, pull the source HTML of a page on the Web:
    #
    #   url = 'https://tantek.com'
    #   markup = Net::HTTP.get(URI.parse(url))
    #
    #   doc = MicroMicro::Document.new(markup, url)
    #
    # @param markup [String] The HTML to parse for microformats2-encoded data.
    # @param base_url [String] The URL associated with markup. Used for relative URL resolution.
    def initialize(markup, base_url)
      @document = Nokogiri::HTML(markup, base_url).resolve_relative_urls!
    end

    # :nocov:
    # @return [String]
    def inspect
      "#<#{self.class}:#{format('%#0x', object_id)} " \
        "items: #{items.inspect}, " \
        "relationships: #{relationships.inspect}>"
    end
    # :nocov:

    # A collection of items parsed from the provided markup.
    #
    # @return [MicroMicro::Collections::ItemsCollection]
    def items
      @items ||= Collections::ItemsCollection.new(Item.items_from(document.element_children))
    end

    # A collection of relationships parsed from the provided markup.
    #
    # @return [MicroMicro::Collections::RelationshipsCollection]
    def relationships
      @relationships ||= Collections::RelationshipsCollection.new(Relationship.relationships_from(document))
    end

    # Return the parsed document as a Hash.
    #
    # @see https://microformats.org/wiki/microformats2-parsing#parse_a_document_for_microformats
    #
    # @return [Hash{Symbol => Array, Hash}]
    def to_h
      {
        items: items.to_a,
        rels: relationships.group_by_rel,
        'rel-urls': relationships.group_by_url
      }
    end

    private

    # @return [Nokogiri::HTML::Document]
    attr_reader :document
  end
end
