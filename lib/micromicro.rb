require 'forwardable'

require 'addressable/uri'
require 'active_support/core_ext/array/grouping'
require 'active_support/core_ext/hash/deep_transform_values'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/object/blank'
require 'nokogiri'

require 'micro_micro/version'
require 'micro_micro/collectible'

require 'micro_micro/parsers/date_time_parser'
require 'micro_micro/parsers/value_class_pattern_parser'

require 'micro_micro/parsers/base_property_parser'
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
require 'micro_micro/implied_property'
require 'micro_micro/relationship'

require 'micro_micro/collections/base_collection'
require 'micro_micro/collections/items_collection'
require 'micro_micro/collections/properties_collection'
require 'micro_micro/collections/relationships_collection'

module MicroMicro
  # Parse a string of HTML for microformats2-encoded data.
  # Convenience method for MicroMicro::Document.new.
  #
  #   MicroMicro.parse('<a href="/" class="h-card" rel="me">Jason Garber</a>', 'https://sixtwothree.org')
  #
  # @param markup [String] The HTML to parse for microformats2-encoded data.
  # @param base_url [String] The URL associated with markup. Used for relative URL resolution.
  # @return [MicroMicro::Document]
  def self.parse(markup, base_url)
    Document.new(markup, base_url)
  end
end
