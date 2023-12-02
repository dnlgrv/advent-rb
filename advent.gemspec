require_relative "lib/advent/version"

Gem::Specification.new do |spec|
  spec.name        = "advent"
  spec.version     = Advent::VERSION
  spec.authors     = ["Daniel Grieve"]
  spec.email       = ["dnlgrv@hey.com"]
  spec.summary     = "Have fun with the Advent of Code using Ruby."
  spec.homepage    = "https://github.com/dnlgrv/advent-rb"
  spec.license     = "MIT"
  spec.files       = Dir["lib/**/*", "LICENSE.txt", "README.md"]
  spec.executables = ["advent"]

  spec.add_dependency "thor", "~> 1.2"
  spec.add_dependency "debug", "~> 1.6"
  spec.add_dependency "rake", "~> 13.0"
  spec.add_dependency "minitest", "~> 5.0"
end
