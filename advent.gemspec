# frozen_string_literal: true

require_relative "lib/advent/version"

Gem::Specification.new do |spec|
  spec.name = "advent"
  spec.version = Advent::VERSION
  spec.authors = ["Daniel Grieve"]
  spec.email = ["dnlgrv@hey.com"]
  spec.summary = "Have fun with the Advent of Code."
  spec.homepage = "https://github.com/dnlgrv/advent"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 2.6.0"

  spec.bindir = "exe"
  spec.files = Dir["lib/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  spec.executables = ["advent"]
  spec.require_paths = ["lib"]
end
