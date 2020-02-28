require 'ostruct'

require 'absolutely'
require 'active_support/core_ext/object/blank'
require 'nokogiri'

require 'micro_micro/version'
require 'micro_micro/exceptions'

require 'micro_micro/document'
require 'micro_micro/relation'

require 'micro_micro/collections/base_collection'
require 'micro_micro/collections/relation_urls_collection'
require 'micro_micro/collections/relations_collection'

module MicroMicro
  def self.parse(markup, base_url)
    Document.new(markup, base_url).to_h
  end
end
