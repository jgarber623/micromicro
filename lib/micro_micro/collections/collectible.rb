module MicroMicro
  module Collections
    module Collectible
      include Enumerable

      # @return [Enumerator, self]
      def each
        return to_enum unless block_given?

        members.each { |member| yield member }

        self
      end

      # @param method [Symbol, String]
      # @param values [List<String>]
      # @return [MicroMicro::Item, MicroMicro::Property, MicroMicro::Relation, nil]
      def find_by(method, *values)
        members.find { |member| values.include?(member.public_send(method)) }
      end

      # @param method [Symbol, String]
      # @param values [List<String>]
      # @return [Array<MicroMicro::Item, MicroMicro::Property, MicroMicro::Relation>]
      def find_all_by(method, *values)
        members.select { |member| values.include?(member.public_send(method)) }
      end

      # @param member [MicroMicro::Item, MicroMicro::Property, MicroMicro::Relation]
      # @return [Array<MicroMicro::Item, MicroMicro::Property, MicroMicro::Relation>]
      # TODO: raise an ArgumentError unless member.is_a?(self.class)
      def push(member)
        members.push(member)
      end

      alias << push
    end
  end
end
