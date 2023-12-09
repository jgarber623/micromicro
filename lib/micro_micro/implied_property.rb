# frozen_string_literal: true

module MicroMicro
  class ImpliedProperty < Property
    IMPLIED_PROPERTY_PARSERS_MAP = {
      "name"  => Parsers::ImpliedNamePropertyParser,
      "photo" => Parsers::ImpliedPhotoPropertyParser,
      "url"   => Parsers::ImpliedUrlPropertyParser
    }.freeze

    private_constant :IMPLIED_PROPERTY_PARSERS_MAP

    # Always return +true+ when asked if this {MicroMicro::ImpliedProperty} is
    # an implied property.
    #
    # @see https://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties
    #   microformats.org: microformats2 parsing specification § Parsing for implied properties
    #
    # @see MicroMicro::Property#implied?
    #
    # @return [Boolean]
    def implied?
      true
    end

    # Always return +false+ when asked if this {MicroMicro::ImpliedProperty} is
    # a {MicroMicro::Item} node.
    #
    # @return [Boolean]
    def item_node?
      false
    end

    private

    def parser
      @parser ||= IMPLIED_PROPERTY_PARSERS_MAP[name].new(self)
    end
  end
end
