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

  spec.add_dependency "thor"
  spec.add_dependency "zeitwerk"

  spec.add_development_dependency "debug"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
end
