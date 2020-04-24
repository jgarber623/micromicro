module MicroMicro
  module Parsers
    class ValueClassPatternParser
      # @see Value Class Pattern sections 3 and 4
      # @see http://microformats.org/wiki/value-class-pattern#Basic_Parsing
      # @see http://microformats.org/wiki/value-class-pattern#Date_and_time_values
      HTML_ATTRIBUTE_MAP = [
        ['alt', %w[area img]],
        ['value', %w[data]],
        ['title', %w[abbr]],
        ['datetime', %w[del ins time]]
      ].freeze

      # @param context [Nokogiri::XML::Element]
      # @param separator [String]
      def initialize(node, separator = '')
        @node = node
        @separator = separator
      end

      # @return [String, nil]
      def value
        @value ||= begin
          return unless values?

          values.join(separator).strip
        end
      end

      # @return [Boolean]
      def value?
        value.present?
      end

      # @return [Array<String>]
      def values
        @values ||= value_nodes.map { |value_node| self.class.value_from(value_node) }.compact.reject(&:empty?)
      end

      # @return [Boolean]
      def values?
        values.any?
      end

      # @param context [Nokogiri::XML::NodeSet, Nokogiri::XML::Element]
      # @param node_set [Nokogiri::XML::NodeSet]
      # @return [Nokogiri::XML::NodeSet]
      def self.nodes_from(context, node_set = Nokogiri::XML::NodeSet.new(context.document, []))
        context.each { |node| nodes_from(node, node_set) } if context.is_a?(Nokogiri::XML::NodeSet)

        if context.is_a?(Nokogiri::XML::Element) && !Document.ignore_node?(context)
          if value_class_node?(context) || value_title_node?(context)
            node_set << context
          else
            nodes_from(context.element_children, node_set)
          end
        end

        node_set
      end

      # @param node [Nokogiri::XML::Element]
      # @return [Boolean]
      def self.value_class_node?(node)
        return unless node['class']

        node['class'].split.include?('value')
      end

      # @param node [Nokogiri::XML::Element]
      # @return [String, nil]
      def self.value_from(node)
        return node['title'] if value_title_node?(node)

        HTML_ATTRIBUTE_MAP.each do |attribute, elements|
          return node[attribute] if elements.include?(node.name) && node[attribute]
        end

        node.text
      end

      # @param node [Nokogiri::XML::Element]
      # @return [Boolean]
      def self.value_title_node?(node)
        return unless node['class']

        node['class'].split.include?('value-title')
      end

      private

      attr_reader :node, :separator

      # @return [Nokogiri::XML::NodeSet]
      def value_nodes
        @value_nodes ||= self.class.nodes_from(node)
      end
    end
  end
end
