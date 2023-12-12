# frozen_string_literal: true

module MicroMicro
  class Relationship
    # The {MicroMicro::RelationshipsCollection} to which this
    # {MicroMicro::Relationship} belongs.
    #
    # @return [MicroMicro::RelationshipsCollection]
    attr_accessor :collection

    # Extract {MicroMicro::Relationship}s from a context.
    #
    # @param context [Nokogiri::HTML5::Document, Nokogiri::XML::Element]
    # @return [Array<MicroMicro::Relationship>]
    def self.from_context(context)
      context
        .css(%([href][rel]:not([rel=""])))
        .filter_map { |node| new(node) unless Helpers.ignore_nodes?(node.ancestors) }
    end

    # Parse a node for relationship data.
    #
    # @param node [Nokogiri::XML::Element]
    # @return [MicroMicro::Relationship]
    def initialize(node)
      @node = node
    end

    # The value of the node's +href+ attribute.
    #
    # @return [String]
    def href
      @href ||= node["href"]
    end

    # The value of the node's +hreflang+ attribute, if present.
    #
    # @return [String, nil]
    def hreflang
      @hreflang ||= node["hreflang"]&.strip
    end

    # @return [String]
    #
    # :nocov:
    def inspect
      "#<#{self.class}:#{format('%#0x', object_id)} " \
        "href: #{href.inspect}, " \
        "rels: #{rels.inspect}>"
    end
    # :nocov:

    # The value of the node's +media+ attribute, if present.
    #
    # @return [String, nil]
    def media
      @media ||= node["media"]&.strip
    end

    # Return the parsed {MicroMicro::Relationship} as a Hash.
    #
    # @return [Hash{Symbol => String}]
    def to_h
      {
        href: href,
        rels: rels,
        hreflang: hreflang,
        media: media,
        title: title,
        type: type,
        text: text
      }.compact_blank!
    end

    # An Array of unique values from node's +rel+ attribute.
    #
    # @return [Array<String>]
    def rels
      @rels ||= Set[*node["rel"].split].to_a.sort
    end

    # The node's text content.
    #
    # @return [String]
    def text
      @text ||= node.text
    end

    # The value of the node's +title+ attribute, if present.
    #
    # @return [String, nil]
    def title
      @title ||= node["title"]&.strip
    end

    # The value of the node's +type+ attribute, if present.
    #
    # @return [String, nil]
    def type
      @type ||= node["type"]&.strip
    end

    private

    # @return [Nokogiri::XML::Element]
    attr_reader :node
  end
end
