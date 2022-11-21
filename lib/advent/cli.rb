# frozen_string_literal: true

require "advent"
require "pathname"
require "thor"

module Advent
  class CLI < Thor
    class_option :root_path, default: Dir.pwd, hide: true, check_default_type: false

    def self.exit_on_failure?
      true
    end

    desc "solve YEAR DAY", "Solve your solution for YEAR and DAY"
    def solve(year, day)
      require "advent/cli/solver"
      Solver.new(self, root_path: root_path, year: year, day: day).solve
    end

    desc "version", "Prints the current version of Advent"
    def version
      say Advent::VERSION
    end

    private

    def root_path
      @_root_path ||= if options.root_path.is_a?(Pathname)
        options.root_path
      else
        Pathname.new(options.root_path)
      end
    end
  end
end
