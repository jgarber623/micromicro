module MicroMicro
  module Collections
    module Collectible
      include Enumerable

      delegate :[], :<<, :each, :last, :length, :push, to: :members

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
    end
  end
end
