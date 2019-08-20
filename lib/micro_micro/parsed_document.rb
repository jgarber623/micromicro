module MicroMicro
  class ParsedDocument
    def initialize(markup)
      raise ArgumentError, "markup must be a String (given #{markup.class})" unless markup.is_a?(String)

      @doc = Nokogiri::HTML(markup)
    end

    def items
      @items ||= []
    end

    def rel_urls
      @rel_urls ||= Parsers::RelUrlsParser.new(@doc).results
    end

    def rels
      @rels ||= Parsers::RelsParser.new(@doc).results
    end

    def to_h
      {
        items:      items,
        rels:       rels.to_h,
        'rel-urls': rel_urls.to_h.transform_values(&:to_h)
      }
    end
  end
end
