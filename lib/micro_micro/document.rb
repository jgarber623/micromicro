module MicroMicro
  class Document
    def initialize(markup, base_url)
      raise ArgumentError, "markup must be a String (given #{markup.class})" unless markup.is_a?(String)
      raise ArgumentError, "base_url must be a String (given #{base_url.class})" unless base_url.is_a?(String)

      @markup = markup
      @base_url = base_url
    end

    def rel_urls
      @rel_urls ||= Collections::RelationUrlsCollection.new(relations_node_set, resolved_base_url)
    end

    def rels
      @rels ||= Collections::RelationsCollection.new(relations_node_set, resolved_base_url)
    end

    def to_h
      @to_h ||= {
        items: [],
        rels: rels.to_h,
        'rel-urls': rel_urls.to_h
      }
    end

    private

    attr_reader :base_url, :markup

    def base_element
      @base_element ||= doc.css('base[href]').first
    end

    def doc
      @doc ||= Nokogiri::HTML(markup)
    end

    def relations_node_set
      @relations_node_set ||= doc.css('[href][rel]')
    end

    def resolved_base_url
      @resolved_base_url ||= begin
        return base_url unless base_element

        Absolutely.to_abs(base: base_url, relative: base_element['href'])
      end
    end
  end
end
