# Changelog

## v3.0.0 / 2022-08-28

- Improved YARD documentation
- New `Item` instance methods (8105d6f):
  - `MicroMicro::Item#children?`
  - `MicroMicro::Item#id?`
- **Breaking change:** Remove property-centric methods from `MicroMicro::Item` (926dedb):
  - `MicroMicro::Item#plain_text_properties`
  - `MicroMicro::Item#url_properties`
- Add predicate methods to `MicroMicro::Collections::PropertiesCollection` (82e91c8):
  - `MicroMicro::Collections::PropertiesCollection#plain_text_properties?`
  - `MicroMicro::Collections::PropertiesCollection#url_properties?`
- Add collections search methods `#where` and `#find_by` (847cb77)
- **Breaking change:** Refactor `.node_set_from` class methods into private classes (b18a714)

## 2.0.1 / 2022-08-20

- Use ruby/debug instead of pry-byebug (2965b2e)
- Update nokogiri-html-ext to v0.2.2 (921c486)
- Include root items with property class names (dd14212)

## 2.0.0 / 2022-08-12

- Refactor implied property parsers (203fec9)
- Add `Helpers` module (caa1c02)
- New `PropertiesCollection` and `Property` instance methods (e9bb38b):
  - `PropertiesCollection#plain_text_properties`
  - `PropertiesCollection#url_properties`
  - `Property#date_time_property?`
  - `Property#embedded_markup_property?`
  - `Property#plain_text_property?`
  - `Property#url_property?`
- Remove Addressable (66c2bb4)
- Refactor classes to use nokogiri-html-ext (33fdf4a)
- Update activesupport (563bf56)
- **Breaking change:** Set minimum supported Ruby to 2.7 (ba17d05)
- Update development Ruby to 2.7.6 (ba17d05)
- Remove Reek (c1e76c5)
- Update runtime dependency version constraints (f83f26a)
- ~~**Breaking change:** Set minimum supported Ruby to 2.6~~ (fc588cd)
- ~~Update development Ruby to 2.6.10~~ (d05a2ac)

## 1.1.0 / 2021-06-10

- Replace Absolutely dependency with Addressable (e93721b)
- Add support for Ruby 3.0 (d897c54)
- Update development Ruby version to 2.6.10 (051c9ad)

## 1.0.0 / 2020-11-08

- Add `MicroMicro::Item#plain_text_properties` and `MicroMicro::Item#url_properties` methods (351e1f1)
- Add `MicroMicro::Collections::RelationshipsCollection#rels` and `MicroMicro::Collections::RelationshipsCollection#urls` methods(c0e5665)
- Add `MicroMicro::Collections::PropertiesCollection#names` and `MicroMicro::Collections::PropertiesCollection#values` methods (65486bc)
- Add `MicroMicro::Collections::ItemsCollection#types` method (6b53a81)
- Update absolutely dependency (4e67bb2)
- Add `Collectible` concern and refactor using Composite design pattern (82503b8)
- Update absolutely dependency (4578fb4)

## 0.1.0 / 2020-05-06

- Initial release!
