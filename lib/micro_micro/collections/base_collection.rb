module MicroMicro
  module Collections
    class BaseCollection
      include Enumerable

      delegate :[], :each, :last, :length, :split, to: :members

      # @param members [Array<MicroMicro::Item, MicroMicro::Property, MicroMicro::Relation>]
      def initialize(members = [])
        @members = members

        decorate_members if respond_to?(:decorate_members, true)
      end

      # @param method [Symbol, String]
      # @param values [List<String>]
      # @return [MicroMicro::Item, MicroMicro::Property, MicroMicro::Relation, nil]
      def find_by(method, *values)
        find { |member| values.include?(member.public_send(method)) }
      end

      # @param method [Symbol, String]
      # @param values [List<String>]
      # @return [Array<MicroMicro::Item, MicroMicro::Property, MicroMicro::Relation>]
      def find_all_by(method, *values)
        select { |member| values.include?(member.public_send(method)) }
      end

      # @param member [MicroMicro::Item, MicroMicro::Property, MicroMicro::Relation]
      # @return [self]
      def push(member)
        members.push(member)

        decorate_members if respond_to?(:decorate_members, true)

        self
      end

      alias << push

      private

      attr_reader :members
    end
  end
end
