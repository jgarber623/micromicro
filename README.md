# MicroMicro

**A Ruby gem for extracting [microformats2](https://microformats.org/wiki/microformats2)-encoded data from HTML documents.**

[![Gem](https://img.shields.io/gem/v/micromicro.svg?logo=rubygems&style=for-the-badge)](https://rubygems.org/gems/micromicro)
[![Downloads](https://img.shields.io/gem/dt/micromicro.svg?logo=rubygems&style=for-the-badge)](https://rubygems.org/gems/micromicro)
[![Build](https://img.shields.io/github/workflow/status/jgarber623/micromicro/CI?logo=github&style=for-the-badge)](https://github.com/jgarber623/micromicro/actions/workflows/ci.yml)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/jgarber623/micromicro.svg?logo=code-climate&style=for-the-badge)](https://codeclimate.com/github/jgarber623/micromicro)
[![Coverage](https://img.shields.io/codeclimate/c/jgarber623/micromicro.svg?logo=code-climate&style=for-the-badge)](https://codeclimate.com/github/jgarber623/micromicro/code)

## Key Features

- Parses microformats2-encoded HTML documents according to the [microformats2 parsing specification](https://microformats.org/wiki/microformats2-parsing)
- Passes all microformats2 tests from [the official test suite](https://github.com/microformats/tests)¹
- Supports Ruby 2.5 and newer

**Note:** MicroMicro **does not** parse [Classic Microformats](https://microformats.org/wiki/Main_Page#Classic_Microformats) (referred to in [the parsing specification](https://microformats.org/wiki/microformats2-parsing#note_backward_compatibility_details) as "backcompat root classes" and "backcompat properties" and in vocabulary specifications in the "Parser Compatibility" sections [e.g. [h-entry](https://microformats.org/wiki/h-entry#Parser_Compatibility)]). To parse documents marked up with Classic Microformats, consider using [the official microformats-ruby parser](https://github.com/microformats/microformats-ruby).

<small>¹ …with some exceptions until [this pull request](https://github.com/microformats/tests/pull/112) is merged.</small>

## Getting Started

Before installing and using MicroMicro, you'll want to have [Ruby](https://www.ruby-lang.org) 2.5 (or newer) installed. It's recommended that you use a Ruby version managment tool like [rbenv](https://github.com/rbenv/rbenv), [chruby](https://github.com/postmodern/chruby), or [rvm](https://github.com/rvm/rvm).

MicroMicro is developed using Ruby 2.5.9 and is additionally tested against Ruby 2.6, 2.7, and 3.0 using [GitHub Actions](https://github.com/jgarber623/micromicro/actions).

## Installation

If you're using [Bundler](https://bundler.io), add MicroMicro to your project's `Gemfile`:

```ruby
source 'https://rubygems.org'

gem 'micromicro'
```

…and hop over to your command prompt and run…

```sh
$ bundle install
```

## Usage

### Basic Usage

MicroMicro's `parse` method accepts two arguments: a `String` of markup and a `String` representing the URL associated with that markup.

The markup (typically HTML) can be retrieved from the Web using a library of your choosing or provided inline as a simple `String` (e.g. `<div class="h-card">Jason Garber</div>`) The URL provided is used to resolve relative URLs in accordance with the document's language rules.

An example using a simple `String` of HTML as input:

```ruby
require 'micromicro'

doc = MicroMicro.parse('<div class="h-card">Jason Garber</div>', 'https://sixtwothree.org')
#=> #<MicroMicro::Document items: #<MicroMicro::Collections::ItemsCollection count: 1, members: [#<MicroMicro::Item types: ["h-card"], properties: 1, children: 0>]>, relationships: #<MicroMicro::Collections::RelationshipsCollection count: 0, members: []>>

doc.to_h
#=> { :items => [{ :type => ["h-card"], :properties => { :name => ["Jason Garber"] } }], :rels => {}, :"rel-urls" => {} }
```

The `Hash` produced by calling `doc.to_h` may be converted to JSON (e.g. `doc.to_h.to_json`) for storage, additional manipulation, or use with other tools.

Another example pulling the source HTML from [Tantek](https://tantek.com)'s website:

```ruby
require 'net/http'
require 'micromicro'

url = 'https://tantek.com'
rsp = Net::HTTP.get(URI.parse(url))

doc = MicroMicro.parse(rsp, url)
#=> #<MicroMicro::Document items: #<MicroMicro::Collections::ItemsCollection count: 1, members: […]>, relationships: #<MicroMicro::Collections::RelationshipsCollection count: 31, members: […]>>

doc.to_h
#=> { :items => [{ :type => ["h-card"], :properties => {…}, :children => […]}], :rels => {…}, :'rel-urls' => {…} }
```

### Advanced Usage

Building on the example above, a MicroMicro-parsed document is navigable and manipulable using a familiar `Enumerable`-esque interface.

#### Items

```ruby
doc.items.first
#=> #<MicroMicro::Item types: ["h-card"], properties: 42, children: 6>

# 🆕 in v1.0.0
doc.items.types
#=> ["h-card"]

doc.items.first.children
#=> #<MicroMicro::Collections::ItemsCollection count: 6, members: […]>
```

#### Properties

```ruby
doc.items.first.properties
#=> #<MicroMicro::Collections::PropertiesCollection count: 42, members: […]>

# 🆕 in v1.0.0
doc.items.first.plain_text_properties
#=> #<MicroMicro::Collections::PropertiesCollection count: 34, members: […]>

# 🆕 in v1.0.0
doc.items.first.url_properties
#=> #<MicroMicro::Collections::PropertiesCollection count: 11, members: […]>

# 🆕 in v1.0.0
doc.items.first.properties.names
#=> ["category", "name", "note", "org", "photo", "pronoun", "pronouns", "role", "uid", "url"]

# 🆕 in v1.0.0
doc.items.first.properties.values
#=> [{:value=>"https://tantek.com/photo.jpg", :alt=>""}, "https://tantek.com/", "Tantek Çelik", "Inventor, writer, teacher, runner, coder, more.", "Inventor", "writer", "teacher", "runner", "coder", …]

doc.items.first.properties[7]
#=> #<MicroMicro::Property name: "category", prefix: "p", value: "teacher">

doc.items.first.properties.take(5).map { |property| [property.name, property.value] }
#=> [["photo", { :value => "https://tantek.com/photo.jpg", :alt => "" }], ["url", "https://tantek.com/"], ["uid", "https://tantek.com/"], ["name", "Tantek Çelik"], ["role", "Inventor, writer, teacher, runner, coder, more."]]
```

#### Relationships

```ruby
doc.relationships.first
#=> #<MicroMicro::Relationship href: "https://tantek.com/", rels: ["canonical"]>

# 🆕 in v1.0.0
doc.relationships.rels
#=> ["alternate", "apple-touch-icon-precomposed", "author", "authorization_endpoint", "bookmark", "canonical", "hub", "icon", "me", "microsub", …]

# 🆕 in v1.0.0
doc.relationships.urls
#=> ["http://dribbble.com/tantek/", "http://last.fm/user/tantekc", "https://aperture.p3k.io/microsub/277", "https://en.wikipedia.org/wiki/User:Tantek", "https://github.com/tantek", "https://indieauth.com/auth", "https://indieauth.com/openid", "https://micro.blog/t", "https://pubsubhubbub.superfeedr.com/", "https://tantek.com/", …]

doc.relationships.find { |relationship| relationship.rels.include?('webmention') }
# => #<MicroMicro::Relationship href: "https://webmention.io/tantek.com/webmention", rels: ["webmention"]>
```

## Contributing

Interested in helping improve MicroMicro? Awesome! Your help is greatly appreciated. See [CONTRIBUTING.md](https://github.com/jgarber623/micromicro/blob/main/CONTRIBUTING.md) for details.

## Acknowledgments

MicroMicro wouldn't exist without the hard work of everyone involved in the [microformats](https://microformats.org) community. Additionally, the comprehensive [microformats test suite](https://github.com/microformats/tests) was invaluable in the development of this Ruby gem.

MicroMicro is written and maintained by [Jason Garber](https://sixtwothree.org).

## License

MicroMicro is freely available under the [MIT License](https://opensource.org/licenses/MIT). Use it, learn from it, fork it, improve it, change it, tailor it to your needs.
