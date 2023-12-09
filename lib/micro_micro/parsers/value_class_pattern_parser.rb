# frozen_string_literal: true

module MicroMicro
  module Parsers
    class ValueClassPatternParser
      # @see https://microformats.org/wiki/value-class-pattern#Basic_Parsing
      #   microformats.org: Value Class Pattern § Basic Parsing
      # @see https://microformats.org/wiki/value-class-pattern#Date_and_time_values
      #   microformats.org: Value Class Pattern § Date and time values
      HTML_ATTRIBUTES_MAP = {
        "alt"      => %w[area img],
        "value"    => %w[data],
        "title"    => %w[abbr],
        "datetime" => %w[del ins time]
      }.freeze

      # @param context [Nokogiri::XML::NodeSet, Nokogiri::XML::Element]
      # @param node_set [Nokogiri::XML::NodeSet]
      # @return [Nokogiri::XML::NodeSet]
      def self.node_set_from(context, node_set = Nokogiri::XML::NodeSet.new(context.document, []))
        context.each { |node| node_set_from(node, node_set) } if context.is_a?(Nokogiri::XML::NodeSet)

        if context.is_a?(Nokogiri::XML::Element) && !Helpers.ignore_node?(context)
          if Helpers.value_class_node?(context) || Helpers.value_title_node?(context)
            node_set << context
          else
            node_set_from(context.element_children, node_set)
          end
        end

        node_set
      end

      # @param node [Nokogiri::XML::Element]
      # @return [String, nil]
      def self.value_from(node)
        return node["title"] if Helpers.value_title_node?(node)

        Helpers.attribute_value_from(node, HTML_ATTRIBUTES_MAP) || node.text
      end

      # @param node [Nokogiri::XML::Element]
      # @param separator [String]
      def initialize(node, separator = "")
        @node = node
        @separator = separator
      end

      # @return [String, nil]
      def value
        @value ||= values.join(separator).strip if values.any?
      end

      # @return [Array<String>]
      def values
        @values ||=
          self.class
              .node_set_from(node)
              .map { |value_node| self.class.value_from(value_node) }
              .compact_blank!
      end

      private

      attr_reader :node, :separator
    end
  end
end
