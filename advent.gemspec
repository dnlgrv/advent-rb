# frozen_string_literal: true

require_relative "lib/advent/version"

Gem::Specification.new do |spec|
  spec.name = "advent"
  spec.version = Advent::VERSION
  spec.authors = ["Daniel Grieve"]
  spec.email = ["dnlgrv@hey.com"]
  spec.summary = "Have fun with the Advent of Code using Ruby."
  spec.homepage = "https://github.com/dnlgrv/advent-rb"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 2.7.0"

  spec.bindir = "exe"
  spec.files = Dir["lib/**/*", "LICENSE.txt", "README.md"]
  spec.executables = ["advent"]
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.2"

  spec.post_install_message = "
advent v0.1.5 requires a config file in your working directory.

See #{spec.homepage}/blob/main/README.md#usage or if you're
brave run `advent init` in your current directory.

"
end
