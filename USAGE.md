# Using MicroMicro

Before using MicroMicro, please read the [Getting Started](https://github.com/jgarber623/micromicro/blob/main/README.md#getting-started) and [Installation](https://github.com/jgarber623/micromicro/blob/main/README.md#installation) sections of the project's [README.md](https://github.com/jgarber623/micromicro/blob/main/README.md).

---

MicroMicro's `parse` method accepts two arguments: a `String` of markup and a `String` representing the URL associated with that markup.

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

## Working with an `ItemsCollection`

A `MicroMicro::Document` includes an `ItemsCollection` which may contain zero or more `MicroMicro::Item`s. An `ItemsCollection` is MicroMicro's representation of the microformats2 canonical JSON's `items` `Array`.

```ruby
doc.items
#=> #<MicroMicro::Collections::ItemsCollection count: 1, members: […]>

doc.items.types
#=> ["h-card"]
```

As noted in the examples below, a `MicroMicro::Item` may also have an `ItemsCollection`, accessible by its `#children` instance method.

### Member: `MicroMicro::Item`

```ruby
item = doc.items.first
#=> #<MicroMicro::Item types: ["h-card"], properties: 42, children: 6>

item.id?
#=> false

item.id
#=> nil

item.types
#=> ["h-card"]

item.children?
#=> true

item.children
#=> #<MicroMicro::Collections::ItemsCollection count: 6, members: […]>
```

## Working with a `PropertiesCollection`

Each `MicroMicro::Item` includes a `PropertiesCollection`, accessible by calling the `Item`'s `#properties` instance method. A `PropertiesCollection` is MicroMicro's representation of the microformats2 canonical JSON's `items[n].properties` `Hash`.

This type of collection includes a number of useful methods for easily retrieving names and values or new collections by `MicroMicro::Property` type.

```ruby
properties = doc.items.first.properties
#=> #<MicroMicro::Collections::PropertiesCollection count: 42, members: […]>

properties.names
#=> ["category", "name", "note", "org", "photo", "pronoun", "pronouns", "role", "uid", "url"]

properties.values
#=> [{:value=>"https://tantek.com/photo.jpg", :alt=>""}, "https://tantek.com/", "Tantek Çelik", "Inventor, writer, teacher, runner, coder, more.", "Inventor", "writer", "teacher", "runner", "coder", …]

properties.plain_text_properties?
#=> true

properties.plain_text_properties
#=> #<MicroMicro::Collections::PropertiesCollection count: 34, members: […]>

properties.url_properties?
#=> true

properties.url_properties
#=> #<MicroMicro::Collections::PropertiesCollection count: 11, members: […]>
```

### Member: `MicroMicro::Property`

```ruby
property = item.properties[7]
#=> #<MicroMicro::Property name: "category", prefix: "p", value: "writer">

property.name
#=> "category"

property.value?
#=> true

property.value
#=> "writer"

property.implied?
#=> false

property.date_time_property?
#=> false

property.embedded_markup_property?
#=> false

property.plain_text_property?
#=> true

property.url_property?
#=> false
```

The `MicroMicro::Property#value` method may also return a `Hash`:

```ruby
property = doc.items.first.properties.first
#=> #<MicroMicro::Property name: "photo", prefix: "u", value: {:value=>"https://tantek.com/photo.jpg", :alt=>""}>

property.value
#=> {:value=>"https://tantek.com/photo.jpg", :alt=>""}
```

A `MicroMicro::Property`'s value may represent a `MicroMicro::Item`. In those cases, the `Item` is detectable and made available:

```ruby
property = doc.items.first.properties[12]
#=> #<MicroMicro::Property name: "pronoun", prefix: "p", value: {:type=>["h-pronoun"], :properties=>{:name=>["he"], :url=>["https://pronoun.is/he"]}, :value=>"he"}>

property.item_node?
#=> true

property.item
#=> #<MicroMicro::Item types: ["h-pronoun"], properties: 2, children: 0>
```

## Working with a `RelationshipsCollection`

A `MicroMicro::Document` includes a `RelationshipsCollection` which may contain zero or more `MicroMicro::Relationship`s. Members of this collection are representations of the original markup's link elements containing `rel` attribute values. The `RelationshipsCollection` is used by MicroMicro to generate the microformats2 canonical JSON's `rels` and `rel-urls` `Hash`es.

```ruby
doc.relationships
#=> #<MicroMicro::Collections::RelationshipsCollection count: 31, members: […]>

doc.relationships.rels
#=> ["alternate", "apple-touch-icon-precomposed", "author", "authorization_endpoint", "bookmark", "canonical", "hub", "icon", "me", "microsub", …]

doc.relationships.urls
#=> ["http://dribbble.com/tantek/", "http://last.fm/user/tantekc", "https://aperture.p3k.io/microsub/277", "https://en.wikipedia.org/wiki/User:Tantek", "https://github.com/tantek", "https://indieauth.com/auth", "https://indieauth.com/openid", "https://micro.blog/t", "https://pubsubhubbub.superfeedr.com/", "https://tantek.com/", …]
```

The `RelationshipsCollection` class includes instance methods, `#group_by_rel` and `#group_by_url`, that return Hashes organized according to the [Parse a hyperlink element for rel microformats](https://microformats.org/wiki/microformats2-parsing#parse_a_hyperlink_element_for_rel_microformats) section of the microformats2 parsing specification.

### Member: `MicroMicro::Relationship`

A `MicroMicro::Relationship`'s instance methods provide quick access to many of the parsed HTML element's attribute values and text content.

```ruby
relationship = doc.relationships.first
#=> #<MicroMicro::Relationship href: "https://tantek.com/", rels: ["canonical"]>

relationship.href
#=> "https://tantek.com/"

relationship.hreflang
#=> nil

relationship.media
#=> nil

relationship.rels
#=> ["canonical"]

relationship.text
#=> ""

relationship.title
#=> nil

relationship.type
#=> nil
```

## Searching a `MicroMicro::Document`

Each of MicroMicro's collection classes include two search methods, `#where` and `#find_by`, inspired by Active Record's query methods of the same name. Both methods accept _either_ a `Hash` of arguments or a block. The `#where` method returns a collection of matched results and the `#find_by` method returns the first matching result (or `nil` when no match is found).

When passing a `Hash` to the search methods, keys should be `Symbol`s matching the name of an instance method present on the collection's members. Values may be a `String` or an `Array` of `String`s. `Array` values will be treated as an intersection match, evaluating to `true` if _any_ element in the `Array` matches.

For example, the code below will find all `MicroMicro::Item`s whose `#types` method includes a value of _either_ `h-card` or `h-feed`:

```ruby
doc.items.where(types: ['h-card', 'h-feed'])
```

When passing a block to the search methods, the resulting collection will include matches where the block evaluates to anything other than `false` or `nil`.

```ruby
doc.items.where { |item| item.id? && item.children? }
```

### Searching an `ItemsCollection`

💡 **Note:** Unlike other collections searches, searching an `ItemsCollection` is recursive. Both `#where` and `#find_by` will search within a `MicroMicro::Item`'s properties (when those properties' values represent an `Item`) and children (when present).

```ruby
doc.items.where(types: 'h-card')
#=> #<MicroMicro::Collections::ItemsCollection count: 8, members: […]>

doc.items.where(types: ['h-card', 'h-feed'])
#=> #<MicroMicro::Collections::ItemsCollection count: 12, members: […]>

doc.items.find_by(types: 'h-feed')
#=> #<MicroMicro::Item types: ["h-feed"], properties: 0, children: 31>
```

### Searching a `PropertiesCollection`

```ruby
item.properties.where(name: ['name', 'url'])
#=> #<MicroMicro::Collections::PropertiesCollection count: 10, members: […]>

item.properties.where { |prop| prop.value.is_a?(Hash) }
#=> #<MicroMicro::Collections::PropertiesCollection count: 10, members: […]>

item.properties.find_by(name: 'url')
#=> #<MicroMicro::Property name: "url", prefix: "u", value: "https://tantek.com/">
```

### Searching a `RelationshipsCollection`

```ruby
doc.relationships.where(rels: ['me', 'webmention'])
#=> #<MicroMicro::Collections::RelationshipsCollection count: 9, members: […]>

doc.relationships.where { |rel| rel.href.match?(%r{https://webmention.io/.+}) }
#=> #<MicroMicro::Collections::RelationshipsCollection count: 1, members: [#<MicroMicro::Relationship href: "https://webmention.io/tantek.com/webmention", rels: ["webmention"]>]>

doc.relationships.find_by(rels: 'webmention')
#=> #<MicroMicro::Relationship href: "https://webmention.io/tantek.com/webmention", rels: ["webmention"]>
```
