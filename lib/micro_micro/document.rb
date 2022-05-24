# frozen_string_literal: true

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

    # :nocov:
    # @return [String]
    def inspect
      "#<#{self.class}:#{format('%#0x', object_id)} " \
        "items: #{items.inspect}, " \
        "relationships: #{relationships.inspect}>"
    end
    # :nocov:

    # A collection of items parsed from the provided markup.
    #
    # @return [MicroMicro::Collections::ItemsCollection]
    def items
      @items ||= Collections::ItemsCollection.new(Item.items_from(document))
    end

    # A collection of relationships parsed from the provided markup.
    #
    # @return [MicroMicro::Collections::RelationshipsCollection]
    def relationships
      @relationships ||= Collections::RelationshipsCollection.new(Relationship.relationships_from(document))
    end

    # Return the parsed document as a Hash.
    #
    # @see https://microformats.org/wiki/microformats2-parsing#parse_a_document_for_microformats
    #
    # @return [Hash{Symbol => Array, Hash}]
    def to_h
      {
        items: items.to_a,
        rels: relationships.group_by_rel,
        'rel-urls': relationships.group_by_url
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

    # @see https://microformats.org/wiki/microformats2-parsing#parse_an_element_for_properties
    # @see https://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
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
          node[attribute] = Addressable::URI.join(resolved_base_url, node[attribute].strip).normalize.to_s
        end
      end

      HTML_IMAGE_CANDIDATE_STRINGS_ATTRIBUTES_MAP.each do |attribute, names|
        document.xpath(*names.map { |name| "//#{name}[@#{attribute}]" }).each do |node|
          candidates = node[attribute].split(',')
                                      .map(&:strip)
                                      .map { |candidate| candidate.match(/^(?<url>.+?)(?<descriptor>\s+.+)?$/) }

          node[attribute] =
            candidates.map do |candidate|
              "#{Addressable::URI.join(resolved_base_url, candidate[:url]).normalize}#{candidate[:descriptor]}"
            end.join(', ')
        end
      end

      self
    end

    # @return [String]
    def resolved_base_url
      @resolved_base_url ||=
        if base_element
          Addressable::URI.join(base_url, base_element['href'].strip).normalize.to_s
        else
          base_url
        end
    end
  end
end
