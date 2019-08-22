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
      @rel_urls ||= Parsers::RelUrlsParser.new(rels_node_set, resolved_base_url).results
    end

    def rels
      @rels ||= Parsers::RelsParser.new(rels_node_set, resolved_base_url).results
    end

    def to_h
      {
        items: items,
        rels: rels.to_h,
        'rel-urls': rel_urls.to_h.transform_values(&:to_h)
      }
    end

    private

    def base_element
      @base_element ||= @doc.css('base[href]').first
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