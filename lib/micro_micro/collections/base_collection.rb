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

      # @return [String]
      def inspect
        format(%(#<#{self.class.name}:%#0x count: #{count}, members: #{members.inspect}>), object_id)
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
