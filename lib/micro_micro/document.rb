module MicroMicro
  class Document
    def initialize(markup, base_url)
      raise ArgumentError, "markup must be a String (given #{markup.class})" unless markup.is_a?(String)
      raise ArgumentError, "base_url must be a String (given #{base_url.class})" unless base_url.is_a?(String)

      @markup = markup
      @base_url = base_url
    end

    def items
      @items ||= ItemCollection.new(doc, resolved_base_url).by_item
    end

    def rel_urls
      @rel_urls ||= relation_collection.by_relation_url
    end

    def rels
      @rels ||= relation_collection.by_relation_type
    end

    def to_h
      {
        items: items.map(&:deep_to_h),
        rels: rels.deep_to_h,
        'rel-urls': rel_urls.deep_to_h
      }
    end

    private

    def base_element
      @base_element ||= doc.css('base[href]').first
    end

    def doc
      @doc ||= Nokogiri::HTML(@markup)
    end

    def relation_collection
      @relation_collection ||= RelationCollection.new(doc.css('[href][rel]'), resolved_base_url)
    end

    def resolved_base_url
      @resolved_base_url ||= begin
        return @base_url unless base_element

        Absolutely.to_abs(base: @base_url, relative: base_element['href'])
      end
    end
  end
end
