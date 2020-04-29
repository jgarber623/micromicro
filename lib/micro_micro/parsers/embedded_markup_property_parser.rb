module MicroMicro
  module Parsers
    class EmbeddedMarkupPropertyParser < BasePropertyParser
      HTML_ATTRIBUTE_NAMES = %w[action cite code codebase data href poster src].freeze

      def value
        @value ||= begin
          {
            html: resolved_node.inner_html.strip,
            value: super
          }
        end
      end

      private

      def resolved_node
        @resolved_node ||= begin
          HTML_ATTRIBUTE_NAMES.each do |attribute|
            node.css("[#{attribute}]").each { |element| element[attribute] = Absolutely.to_abs(base: node.document.url, relative: element[attribute].strip) }
          end

          node
        end
      end
    end
  end
end
