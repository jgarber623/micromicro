module MicroMicro
  class ImpliedProperty < Property
    IMPLIED_PROPERTY_PARSERS_MAP = {
      'name'  => Parsers::ImpliedNamePropertyParser,
      'photo' => Parsers::ImpliedPhotoPropertyParser,
      'url'   => Parsers::ImpliedUrlPropertyParser
    }.freeze

    # @return [Boolean]
    def implied?
      true
    end

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
