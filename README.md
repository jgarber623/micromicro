> [!IMPORTANT]
> This project has moved to [codeberg.org/jgarber/micromicro](https://codeberg.org/jgarber/micromicro).
> 
# MicroMicro

**A Ruby gem for extracting [microformats2](https://microformats.org/wiki/microformats2)-encoded data from HTML documents.**

[![Gem](https://img.shields.io/gem/v/micromicro.svg?logo=rubygems&style=for-the-badge)](https://rubygems.org/gems/micromicro)
[![Downloads](https://img.shields.io/gem/dt/micromicro.svg?logo=rubygems&style=for-the-badge)](https://rubygems.org/gems/micromicro)
[![Build](https://img.shields.io/github/actions/workflow/status/jgarber623/micromicro/ci.yml?branch=main&logo=github&style=for-the-badge)](https://github.com/jgarber623/micromicro/actions/workflows/ci.yml)

## Key Features

- Parses microformats2-encoded HTML documents according to the [microformats2 parsing specification](https://microformats.org/wiki/microformats2-parsing)
- Passes all microformats2 tests from [the official test suite](https://github.com/microformats/tests)¹
- Supports Ruby 3.0 and newer

**Note:** MicroMicro **does not** parse [Classic Microformats](https://microformats.org/wiki/Main_Page#Classic_Microformats) (referred to in [the parsing specification](https://microformats.org/wiki/microformats2-parsing#note_backward_compatibility_details) as "backcompat root classes" and "backcompat properties" and in vocabulary specifications in the "Parser Compatibility" sections [e.g. [h-entry](https://microformats.org/wiki/h-entry#Parser_Compatibility)]). To parse documents marked up with Classic Microformats, consider using [the official microformats-ruby parser](https://github.com/microformats/microformats-ruby).

<small>¹ …with some exceptions until [this pull request](https://github.com/microformats/tests/pull/112) is merged.</small>

## Installation

Before installing and using MicroMicro, you'll want to have [Ruby](https://www.ruby-lang.org) 3.0 (or newer) installed. If you're using [Bundler](https://bundler.io) to manage gem dependencies, add MicroMicro to your project's Gemfile:

```ruby
gem 'micromicro'
```

…and run `bundle install` in your shell.

To install the gem manually, run the following in your shell:

```sh
gem install micromicro
```

## Usage

MicroMicro's `parse` method accepts two arguments: a `String` of markup and a `String` representing the URL associated with that markup. The resulting `MicroMicro::Document` may be converted to a `Hash` which may be further manipulated using conventional Ruby tooling.

```ruby
require 'micromicro'

doc = MicroMicro.parse('<div class="h-card">Jason Garber</div>', 'https://sixtwothree.org')
#=> #<MicroMicro::Document items: #<MicroMicro::Collections::ItemsCollection count: 1, members: [#<MicroMicro::Item types: ["h-card"], properties: 1, children: 0>]>, relationships: #<MicroMicro::Collections::RelationshipsCollection count: 0, members: []>>

doc.to_h
#=> { :items => [{ :type => ["h-card"], :properties => { :name => ["Jason Garber"] } }], :rels => {}, :"rel-urls" => {} }
```

See [USAGE.md](https://github.com/jgarber623/micromicro/blob/main/USAGE.md) for detailed examples of MicroMicro's features. Additional structured documentation is available on [RubyDoc.info](https://rubydoc.info/gems/micromicro).

## Acknowledgments

MicroMicro wouldn't exist without the hard work of everyone involved in the [microformats](https://microformats.org) community. Additionally, the comprehensive [microformats test suite](https://github.com/microformats/tests) was invaluable in the development of this Ruby gem.

MicroMicro is written and maintained by [Jason Garber](https://sixtwothree.org).

## License

MicroMicro is freely available under the [MIT License](https://opensource.org/licenses/MIT). Use it, learn from it, fork it, improve it, change it, tailor it to your needs.
