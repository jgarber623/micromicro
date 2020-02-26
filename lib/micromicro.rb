require 'ostruct'

require 'absolutely'
require 'active_support/core_ext/object/blank'
require 'nokogiri'

require 'micro_micro/version'
require 'micro_micro/exceptions'

require 'micro_micro/core_ext/ostruct'

require 'micro_micro/document'
require 'micro_micro/item_collection'
require 'micro_micro/item'
require 'micro_micro/relation_collection'
require 'micro_micro/relation'

module MicroMicro
  def self.parse(markup, base_url)
    Document.new(markup, base_url).to_h
  end
end
