# frozen_string_literal: true

module MicroMicro
  module Collections
    class BaseCollection
      extend Forwardable

      include Enumerable

      def_delegators :members, :[], :each, :last, :length, :split

      # @param members [Array<MicroMicro::Item, MicroMicro::Property, MicroMicro::Relationship>]
      def initialize(members = [])
        members.each { |member| push(member) }
      end

      # @return [String]
      def inspect
        format(%(#<#{self.class.name}:%#0x count: #{count}, members: #{members.inspect}>), object_id)
      end

      # @param member [MicroMicro::Item, MicroMicro::Property, MicroMicro::Relationship]
      def push(member)
        members << member

        member.collection = self
      end

      alias << push

      private

      def members
        @members ||= []
      end
    end
  end
end
