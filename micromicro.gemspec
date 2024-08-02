# frozen_string_literal: true

require_relative "lib/micro_micro/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 3.0"

  spec.name          = "micromicro"
  spec.version       = MicroMicro::VERSION
  spec.authors       = ["Jason Garber"]
  spec.email         = ["jason@sixtwothree.org"]

  spec.summary       = "Extract microformats2-encoded data from HTML documents."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/jgarber623/micromicro"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"].reject { |f| File.directory?(f) }
  spec.files        += ["LICENSE", "CHANGELOG.md", "README.md"]
  spec.files        += ["micromicro.gemspec"]

  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri"       => "#{spec.homepage}/issues",
    "changelog_uri"         => "#{spec.homepage}/releases/tag/v#{spec.version}",
    "rubygems_mfa_required" => "true",
    "source_code_uri"       => "#{spec.homepage}/tree/v#{spec.version}"
  }

  spec.add_dependency "activesupport", "~> 7.0"
  spec.add_dependency "nokogiri", ">= 1.14"
  spec.add_dependency "nokogiri-html-ext", "~> 0.4.0"
end
