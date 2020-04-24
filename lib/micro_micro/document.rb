module MicroMicro
  class Document
    # @param markup [String] the HTML to parse
    # @param base_url [String] the URL associated with the provided markup
    def initialize(markup, base_url)
      @markup = markup
      @base_url = base_url
    end

    # @return [MicroMicro::Collections::ItemsCollection]
    def items
      @items ||= Collections::ItemsCollection.new(Item.nodes_from(document))
    end

    # @see microformats2 Parsing Specification section 1.1
    # @see http://microformats.org/wiki/microformats2-parsing#parse_a_document_for_microformats
    #
    # @return [Hash]
    def to_h
      {
        items: items.to_a,
        rels: {},
        'rel-urls': {}
      }
    end

    def self.ignore_node?(node)
      ignored_node_names.include?(node.name)
    end

    def self.ignored_node_names
      %w[script style template]
    end

    private

    attr_reader :base_url, :markup

    # @return [Nokogiri::XML::Element, nil]
    def base_element
      @base_element ||= Nokogiri::HTML(markup).at_css('base[href]')
    end

    # @return [Nokogiri::HTML::Document]
    def document
      @document ||= Nokogiri::HTML(markup, resolved_base_url)
    end

    # @return [String]
    def resolved_base_url
      @resolved_base_url ||= begin
        return base_url unless base_element

        Absolutely.to_abs(base: base_url, relative: base_element['href'])
      end
    end
  end
end
