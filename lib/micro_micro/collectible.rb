module MicroMicro
  module Collectible
    attr_accessor :collection

    def next_all
      collection.split(self).last
    end

    def prev_all
      collection.split(self).first
    end
  end
end
