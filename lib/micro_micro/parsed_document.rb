module MicroMicro
  class ParsedDocument
    def initialize(markup, base_url)
      raise ArgumentError, "markup must be a String (given #{markup.class})" unless markup.is_a?(String)
      raise ArgumentError, "base_url must be a String (given #{base_url.class})" unless base_url.is_a?(String)

      @doc = Nokogiri::HTML(markup)
      @base_url = base_url
    end

    def items
      @items ||= []
    end

    def rel_urls
      @rel_urls ||= parsed_relation_collection.by_relation_url
    end

    def rels
      @rels ||= parsed_relation_collection.by_relation_type
    end

    def to_h
      {
        items: items,
        rels: rels.deep_to_h,
        'rel-urls': rel_urls.deep_to_h
      }
    end

    private

    def base_element
      @base_element ||= @doc.css('base[href]').first
    end

    def parsed_relation_collection
      @parsed_relation_collection ||= ParsedRelationCollection.new(rels_node_set, resolved_base_url)
    end

    def rels_node_set
      @rels_node_set ||= @doc.css('[href][rel]')
    end

    def resolved_base_url
      @resolved_base_url ||= begin
        return @base_url unless base_element

        Absolutely.to_abs(base: @base_url, relative: base_element['href'])
      end
    end
  end
end
