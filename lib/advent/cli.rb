# frozen_string_literal: true

require "advent"
require "pathname"
require "thor"

module Advent
  class CLI < Thor
    include Thor::Actions

    class_option :root_path, default: Dir.pwd, hide: true, check_default_type: false

    def initialize(*args)
      super

      self.destination_root = root_path
      source_paths << File.expand_path("templates", __dir__)
    end

    # @return [Boolean] defines whether an exit status is set if a command fails
    def self.exit_on_failure?
      true
    end

    no_commands do
      # @return [Boolean] whether the current root_path option is in a
      # directory that looks like a year (eg. 2015)
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

    desc "generate YEAR DAY", "Generate a new solution for YEAR and DAY"

    # Generates a new solution file. If within a year directory, only the day
    # is used, otherwise both the year and day will be required to generate the
    # output.
    def generate(year_or_day, day = nil)
      destination = if in_year_directory?
        "day#{year_or_day}.rb"
      else
        "#{year_or_day}/day#{day}.rb"
      end

      template "solution.rb.tt", destination, context: binding
    end

    desc "solve YEAR DAY", "Solve your solution for YEAR and DAY"

    # Runs a solution, outputting both :part1 and :part2 method return values.
    def solve(year, day)
      require "advent/cli/solver"
      Solver.new(self, year: year, day: day).solve
    end

    desc "version", "Prints the current version of the gem"
    # Prints the current version of the gem
    def version
      say Advent::VERSION
    end
  end
end
