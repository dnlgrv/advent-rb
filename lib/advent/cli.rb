require "thor"

module Advent
  class CLI < Thor
    desc "version", "Prints the current version of Advent"
    def version
      require "advent/version"
      say Advent::VERSION
    end
  end
end
