# frozen_string_literal: true

require_relative 'lib/rangescan/version'

Gem::Specification.new do |spec|
  spec.name          = "rangescan"
  spec.version       = RangeScan::VERSION
  spec.authors       = ["Manabu Niseki"]
  spec.email         = ["manabu.niseki@gmail.com"]

  spec.summary       = "Scan websites on a specific IP range"
  spec.description   = "A CLI tool to scan websites on a specific IP range"
  spec.homepage      = "https://github.com/ninoseki/rangescan"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "glint", "~> 0.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "webmock", "~> 3.8"

  spec.add_dependency "http", "~> 4.4"
  spec.add_dependency "ipaddress", "~> 0.8"
  spec.add_dependency "parallel", "~> 1.19"
  spec.add_dependency "thor", "~> 1.0"
end
