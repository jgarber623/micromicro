require 'ostruct'

require 'active_support/core_ext/object/blank'
require 'nokogiri'

require 'micro_micro/version'
require 'micro_micro/exceptions'

require 'micro_micro/parsers/base_rel_parser'
require 'micro_micro/parsers/rel_urls_parser'
require 'micro_micro/parsers/rels_parser'

require 'micro_micro/parsed_document'

module MicroMicro
  def self.parse(markup)
    ParsedDocument.new(markup).to_h
  end
end
