# Changelog

> [!NOTE]
> From v6.0.0, changes are documented using [GitHub Releases](https://github.com/jgarber623/micromicro/releases). For a given release, metadata on RubyGems.org will link to that version's Release page.

## 5.0.1 / 2024-01-01

- Use rubygems/release-gem action (#81) (ab39770)
- RuboCop: Style/WordArray (227a223)
- RuboCop: Style/StringLiteralsInInterpolation (f5c350c)
- RuboCop: Style/SymbolArray (6ccd949)
- RuboCop: Performance/StringIdentifierArgument (477e25a)
- Add `source_code_uri` to metadata (b3f49cf)

## 5.0.0 / 2023-12-11

- Remove upper version constraint (#79) (86f09d8)
- Miscellaneous cleanup (#78) (4023177)
  - **Breaking change:** remove `Collectible` module (`next_all` and `prev_all`
    no longer mixed in to various collection classes)
  - reduce reliance on ActiveSupport
- Address RuboCop Performance warnings (#77) (2d5d0c2)
- RuboCop formatting fixes (#76) (9ab491e)
- RuboCop: Single quotes within interpolated string (#75) (37f66c0)
- RuboCop: `Style/StringLiterals` (#74) (918b58a)
- Address RuboCop `Style/StringLiterals` warnings' (#73) (3fb3cf4)
- Add IRB config file (#72) (1ce9fab)
- Update project files (#71) (85a5dd4)
- Remove CodeClimate references (#70) (0b86c34)
- RuboCop: `Style/PerlBackrefs` (a360af0)
- RuboCop: `Lint/RedundantDirGlobSort` (15c8aca)
- RuboCop: `Style/RedundantRegexpArgument` (8c93eb7)
- RuboCop: `Style/RedundantFreeze` (feaee51)
- **Breaking change:** Set minimum supported Ruby to 3.0 (f39dbef)
- **Breaking change:** Update development Ruby to v3.0.6 (6869e22)

## 4.0.0 / 2023-03-14

- Parse HTML with `Nokogiri::HTML5::Document.parse` (330a2d1, 0de40d7)
- Update Nokogiri and nokogiri-html-ext constraints (e038606, cb6e499, 9793b17)
- Remove code-scanning-rubocop and rspec-github gems (2fbb9c5)
- Update development Ruby to v2.7.7 (a333103)

## 3.1.0 / 2022-09-24

- **New feature:** parse `img[srcset]` (microformats/microformats2-parsing#7) (cdda328)
- Improve usage of activesupport extensions (5ed120c)

## 3.0.0 / 2022-08-28

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
