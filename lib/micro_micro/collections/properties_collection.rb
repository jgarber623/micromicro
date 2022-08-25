# frozen_string_literal: true

module MicroMicro
  module Collections
    class PropertiesCollection < BaseCollection
      # Retrieve an Array of this collection's unique {MicroMicro::Property}
      # names.
      #
      # @see MicroMicro::Property#name
      #
      # @return [Array<String>]
      def names
        @names ||= map(&:name).uniq.sort
      end

      # A collection of plain text {MicroMicro::Property}s parsed from the node.
      #
      # @see MicroMicro::Property#plain_text_property?
      #
      # @return [MicroMicro::Collections::PropertiesCollection]
      def plain_text_properties
        self.class.new(select(&:plain_text_property?))
      end

      # Return a Hash of this collection's {MicroMicro::Property}s as Arrays.
      #
      # @see MicroMicro::Property#name
      # @see MicroMicro::Property#value
      #
      # @return [Hash{Symbol => Array<String, Hash>}]
      def to_h
        group_by(&:name).symbolize_keys.deep_transform_values(&:value)
      end

      # A collection of url {MicroMicro::Property}s parsed from the node.
      #
      # @see MicroMicro::Property#url_property?
      #
      # @return [MicroMicro::Collections::PropertiesCollection]
      def url_properties
        self.class.new(select(&:url_property?))
      end

      # Return an Array of this collection's unique {MicroMicro::Property}
      # values.
      #
      # @see MicroMicro::Property#value
      #
      # @return [Array<String, Hash>]
      def values
        @values ||= map(&:value).uniq
      end
    end
  end
end
