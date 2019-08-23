require 'ostruct'

require 'absolutely'
require 'active_support/core_ext/object/blank'
require 'nokogiri'

require 'micro_micro/version'
require 'micro_micro/exceptions'

require 'micro_micro/core_ext/ostruct'

require 'micro_micro/parsed_relation_collection'
require 'micro_micro/parsed_relation'

require 'micro_micro/parsed_document'

module MicroMicro
  def self.parse(markup, base_url)
    ParsedDocument.new(markup, base_url).to_h
  end
end
