# frozen_string_literal: true

require_relative "lib/bitrix24/core/version"

Gem::Specification.new do |spec|
  spec.name = "bitrix24"
  spec.version = Bitrix24::Core::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["gildemberg-santos"]
  spec.email = ["gildemberg.santos@gmail.com"]
  spec.summary = "Bitrix24 Ruby API Gem"
  spec.description = "Bitrix24 Ruby API client"
  spec.homepage = "http://github.com/gildemberg-santos/bitrix24"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.10"

  spec.metadata["allowed_push_host"] = ""
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 5.2.8.1"
  spec.add_dependency "httparty", ">= 0.21.0"
  spec.add_dependency "rake", ">= 12.0.0"
  spec.add_dependency "u-case", ">= 4.5.2"

  spec.metadata["rubygems_mfa_required"] = "true"
end
