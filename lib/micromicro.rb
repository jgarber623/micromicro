require 'absolutely'
require 'active_support/core_ext/hash/deep_transform_values'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/object/blank'
require 'nokogiri'

require 'micro_micro/version'

require 'micro_micro/parsers/attributes_parser'
require 'micro_micro/parsers/value_class_pattern_parser'

require 'micro_micro/parsers/base_property_parser'
require 'micro_micro/parsers/date_time_parser'
require 'micro_micro/parsers/date_time_property_parser'
require 'micro_micro/parsers/embedded_markup_property_parser'
require 'micro_micro/parsers/implied_name_property_parser'
require 'micro_micro/parsers/implied_photo_property_parser'
require 'micro_micro/parsers/implied_url_property_parser'
require 'micro_micro/parsers/plain_text_property_parser'
require 'micro_micro/parsers/url_property_parser'

require 'micro_micro/document'
require 'micro_micro/item'
require 'micro_micro/property'
require 'micro_micro/relation'

require 'micro_micro/collections/collectible'
require 'micro_micro/collections/items_collection'
require 'micro_micro/collections/properties_collection'
require 'micro_micro/collections/relations_collection'

module MicroMicro
  def self.parse(markup, base_url)
    Document.new(markup, base_url)
  end
end
