# frozen_string_literal: true

require "advent"
require "date"
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
      year, day = if in_year_directory?
        [root_path.basename.to_s, parse_number(year_or_day)]
      else
        [year_or_day, parse_number(day)]
      end

      if (error_message = validate(year, day))
        say_error error_message, :red
        return
      end

      subpath = if in_year_directory?
        ""
      else
        "#{year}/"
      end

      template "solution.rb.tt", "#{subpath}day#{day}.rb", context: binding
      template "solution_test.rb.tt", "#{subpath}test/day#{day}_test.rb", context: binding
    end

    desc "solve FILE", "Solve your solution"
    # Runs a solution file, outputting both :part1 and :part2 method return values.
    def solve(path)
      require "advent/cli/solver"
      Solver.new(self, root_path.join(path)).solve
    end

    desc "version", "Prints the current version of the gem"
    # Prints the current version of the gem
    def version
      say Advent::VERSION
    end

    private

    def parse_number(str)
      if (m = str.match(/[0-9]+/))
        m[0]
      end
    end

    def validate(year, day)
      if year.to_i < 2014
        "Advent of Code only started in 2014!"
      elsif year.to_i > Date.today.year
        "Future years are not supported."
      elsif !(1..25).cover? day.to_i
        "Day must be between 1 and 25 (inclusive)."
      end
    end
  end
end
