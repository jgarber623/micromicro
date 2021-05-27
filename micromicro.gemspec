require_relative 'lib/micro_micro/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5', '< 4')

  spec.name          = 'micromicro'
  spec.version       = MicroMicro::VERSION
  spec.authors       = ['Jason Garber']
  spec.email         = ['jason@sixtwothree.org']

  spec.summary       = 'Extract microformats2-encoded data from HTML documents.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/jgarber623/micromicro'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*'].reject { |f| File.directory?(f) }
  spec.files        += %w[LICENSE CHANGELOG.md CONTRIBUTING.md README.md]
  spec.files        += %w[micromicro.gemspec]

  spec.require_paths = ['lib']

  spec.metadata['bug_tracker_uri'] = "#{spec.homepage}/issues"
  spec.metadata['changelog_uri']   = "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"

  spec.add_runtime_dependency 'addressable', '~> 2.7'
  spec.add_runtime_dependency 'activesupport', '~> 6.1'
  spec.add_runtime_dependency 'nokogiri', '~> 1.11'
end
