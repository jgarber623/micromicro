module MicroMicro
  class Document
    # A map of HTML `srcset` attributes and their associated element names
    #
    # @see https://html.spec.whatwg.org/#srcset-attributes
    # @see https://html.spec.whatwg.org/#attributes-3
    HTML_IMAGE_CANDIDATE_STRINGS_ATTRIBUTES_MAP = {
      'imagesrcset' => %w[link],
      'srcset'      => %w[img source]
    }.freeze

    # A map of HTML URL attributes and their associated element names
    #
    # @see https://html.spec.whatwg.org/#attributes-3
    HTML_URL_ATTRIBUTES_MAP = {
      'action'     => %w[form],
      'cite'       => %w[blockquote del ins q],
      'data'       => %w[object],
      'formaction' => %w[button input],
      'href'       => %w[a area base link],
      'manifest'   => %w[html],
      'ping'       => %w[a area],
      'poster'     => %w[video],
      'src'        => %w[audio embed iframe img input script source track video]
    }.freeze

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
      @markup = markup
      @base_url = base_url

      resolve_relative_urls
    end

    # @return [String]
    def inspect
      format(%(#<#{self.class.name}:%#0x items: #{items.inspect}, relations: #{relations.inspect}>), object_id)
    end

    # A collection of items parsed from the provided markup.
    #
    # @return [MicroMicro::Collections::ItemsCollection]
    def items
      @items ||= Collections::ItemsCollection.new(Item.items_from(document))
    end

    # A collection of relations parsed from the provided markup.
    #
    # @return [MicroMicro::Collections::RelationsCollection]
    def relations
      @relations ||= Collections::RelationsCollection.new(Relation.relations_from(document))
    end

    # Return the parsed document as a Hash.
    #
    # @see http://microformats.org/wiki/microformats2-parsing#parse_a_document_for_microformats
    #
    # @return [Hash]
    def to_h
      {
        items: items.to_a,
        rels: relations.group_by_rel,
        'rel-urls': relations.group_by_url
      }
    end

    # Ignore this node?
    #
    # @param node [Nokogiri::XML::Element]
    # @return [Boolean]
    def self.ignore_node?(node)
      ignored_node_names.include?(node.name)
    end

    # A list of HTML element names the parser should ignore.
    #
    # @return [Array<String>]
    def self.ignored_node_names
      %w[script style template]
    end

    # @see http://microformats.org/wiki/microformats2-parsing#parse_an_element_for_properties
    # @see http://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
    #
    # @param context [Nokogiri::HTML::Document, Nokogiri::XML::NodeSet, Nokogiri::XML::Element]
    # @yield [context]
    # @return [String]
    def self.text_content_from(context)
      context.css(*ignored_node_names).unlink

      yield(context) if block_given?

      context.text.strip
    end

    private

    attr_reader :base_url, :markup

    # @return [Nokogiri::XML::Element, nil]
    def base_element
      @base_element ||= Nokogiri::HTML(markup).at('//base[@href]')
    end

    # @return [Nokogiri::HTML::Document]
    def document
      @document ||= Nokogiri::HTML(markup, resolved_base_url)
    end

    def resolve_relative_urls
      HTML_URL_ATTRIBUTES_MAP.each do |attribute, names|
        document.xpath(*names.map { |name| "//#{name}[@#{attribute}]" }).each do |node|
          node[attribute] = Absolutely.to_abs(base: resolved_base_url, relative: node[attribute].strip)
        end
      end

      HTML_IMAGE_CANDIDATE_STRINGS_ATTRIBUTES_MAP.each do |attribute, names|
        document.xpath(*names.map { |name| "//#{name}[@#{attribute}]" }).each do |node|
          candidates = node[attribute].split(',').map(&:strip).map { |candidate| candidate.match(/^(?<url>.+?)(?<descriptor>\s+.+)?$/) }

          node[attribute] = candidates.map { |candidate| "#{Absolutely.to_abs(base: resolved_base_url, relative: candidate[:url])}#{candidate[:descriptor]}" }.join(', ')
        end
      end

      self
    end

    # @return [String]
    def resolved_base_url
      @resolved_base_url ||= begin
        return base_url unless base_element

        Absolutely.to_abs(base: base_url, relative: base_element['href'].strip)
      end
    end
  end
end
