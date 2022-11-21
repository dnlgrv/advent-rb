# frozen_string_literal: true

require "advent"
require "pathname"
require "thor"

module Advent
  class CLI < Thor
    class_option :root_path, default: Dir.pwd, hide: true, check_default_type: false

    def initialize(*args)
      super

      self.destination_root = root_path
      source_paths << File.expand_path("templates", __dir__)
    end

    def self.exit_on_failure?
      true
    end

    no_commands do
      def in_year_directory?
        dir = root_path.basename.to_s
        dir =~ /^20[0-9]{2}/
      end

      def root_path
        @_root_path ||= if options.root_path.is_a?(Pathname)
          options.root_path
        else
          Pathname.new(options.root_path)
        end
      end
    end

    desc "solve YEAR DAY", "Solve your solution for YEAR and DAY"
    def solve(year, day)
      require "advent/cli/solver"
      Solver.new(self, year: year, day: day).solve
    end

    desc "version", "Prints the current version of Advent"
    def version
      say Advent::VERSION
    end
  end
end
