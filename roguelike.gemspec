# frozen_string_literal: true

require_relative "lib/roguelike/version"

Gem::Specification.new do |spec|
  spec.name          = "roguelike"
  spec.version       = Roguelike::VERSION
  spec.authors       = ["Matheus Richard"]
  spec.email         = ["matheus.richard@fretadao.com.br"]

  spec.summary       = "A roguelike"
  spec.description   = "A roguelike"
  spec.homepage      = "https://github.com/MatheusRich/roguelike"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
