# frozen_string_literal: true

module MicroMicro
  class Document
    # Parse a string of HTML for microformats2-encoded data.
    #
    # @example Parse a String of markup
    #   MicroMicro::Document.new(%(<a href="/" class="h-card" rel="me">Jason Garber</a>), "https://sixtwothree.org")
    #
    # @example Parse a String of markup from a URL
    #   url = "https://tantek.com"
    #   markup = Net::HTTP.get(URI.parse(url))
    #
    #   doc = MicroMicro::Document.new(markup, url)
    #
    # @param markup [String] The HTML to parse for microformats2-encoded data.
    # @param base_url [String] The URL associated with markup. Used for relative URL resolution.
    def initialize(markup, base_url)
      @document = Nokogiri::HTML5::Document.parse(markup, base_url).resolve_relative_urls!
    end

    # @return [String]
    #
    # :nocov:
    def inspect
      "#<#{self.class}:#{format("%#0x", object_id)} " \
        "items: #{items.inspect}, " \
        "relationships: #{relationships.inspect}>"
    end
    # :nocov:

    # A collection of {MicroMicro::Item}s parsed from the provided markup.
    #
    # @return [MicroMicro::Collections::ItemsCollection]
    def items
      @items ||= Collections::ItemsCollection.new(Item.from_context(document.element_children))
    end

    # A collection of {MicroMicro::Relationship}s parsed from the provided markup.
    #
    # @return [MicroMicro::Collections::RelationshipsCollection]
    def relationships
      @relationships ||= Collections::RelationshipsCollection.new(Relationship.from_context(document))
    end

    # Return the parsed document as a Hash.
    #
    # @see https://microformats.org/wiki/microformats2-parsing#parse_a_document_for_microformats
    #   microformats.org: Parse a document for microformats
    #
    # @see MicroMicro::Collections::ItemsCollection#to_a
    # @see MicroMicro::Collections::RelationshipsCollection#group_by_rel
    # @see MicroMicro::Collections::RelationshipsCollection#group_by_url
    #
    # @return [Hash{Symbol => Array, Hash}]
    def to_h
      {
        items: items.to_a,
        rels: relationships.group_by_rel,
        "rel-urls": relationships.group_by_url
      }
    end

    private

    # @return [Nokogiri::HTML5::Document]
    attr_reader :document
  end
end
