module MicroMicro
  class Relation
    # @param node [Nokogiri::XML::Element]
    def initialize(node)
      @node = node
    end

    # @return [String]
    def href
      @href ||= Absolutely.to_abs(base: node.document.url, relative: node['href'].strip)
    end

    # @return [String, nil]
    def hreflang
      @hreflang ||= node['hreflang']&.strip
    end

    # @return [String]
    def inspect
      format(%(#<#{self.class.name}:%#0x href: #{href.inspect}, rels: #{rels.inspect}>), object_id)
      # format(%(#<#{self.class.name}:%#0x rels: #{rels}>), object_id)
    end

    # @return [String, nil]
    def media
      @media ||= node['media']&.strip
    end

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
      }.select { |_, value| value.present? }
    end

    # @return [Array<String>]
    def rels
      @rels ||= node['rel'].split.uniq.sort
    end

    # @return [String]
    def text
      @text ||= node.text
    end

    # @return [String, nil]
    def title
      @title ||= node['title']&.strip
    end

    # @return [String, nil]
    def type
      @type ||= node['type']&.strip
    end

    # @param context [Nokogiri::HTML::Document, Nokogiri::XML::Element]
    # @return [Nokogiri::XML::NodeSet]
    def self.nodes_from(context)
      context.css('[href][rel]:not([rel=""])').reject { |node| (node.ancestors.map(&:name) & Document.ignored_node_names).any? }
    end

    # @param context [Nokogiri::HTML::Document, Nokogiri::XML::Element]
    # @return [Array<MicroMicro::Relation>]
    def self.relations_from(context)
      nodes_from(context).map { |node| new(node) }
    end

    private

    attr_reader :node
  end
end
