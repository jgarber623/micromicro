module MicroMicro
  module Collections
    class BaseCollection
      include Enumerable

      def initialize(node_set, base_url)
        @node_set = node_set
        @base_url = base_url
      end

      def each
        return to_enum unless block_given?

        members.each { |member| yield member }

        self
      end

      def empty?
        count.zero?
      end

      def last
        members.last
      end

      private

      attr_reader :base_url, :node_set
    end
  end
end
