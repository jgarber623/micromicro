module MicroMicro
  class Relation
    def initialize(node, base_url)
      @node = node
      @base_url = base_url
    end

    def attributes
      @attributes ||= OpenStruct.new(selected_attributes)
    end

    def url
      @url ||= Absolutely.to_abs(base: base_url, relative: node['href'].strip)
    end

    private

    attr_reader :base_url, :node

    def base_attributes
      {
        rels: node['rel'].strip.split(/\s+/).uniq.sort,
        text: node.content
      }
    end

    def extended_attributes
      node.attributes.select { |key, _| %w[hreflang media title type].include?(key) }.transform_values { |value| value.to_s.strip }
    end

    def selected_attributes
      base_attributes.merge(extended_attributes).select { |_, value| value.present? }
    end
  end
end
