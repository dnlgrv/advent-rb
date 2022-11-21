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
      if in_year_directory?
        require root_path.join("day#{day}.rb").to_s
      else
        require root_path.join(year.to_s, "day#{day}.rb")
      end

      solution = Object.const_get("Day#{day}").new

      part1_value = if solution.respond_to?(:part1)
        solution.part1
      else
        "Missing"
      end

      part2_value = if solution.respond_to?(:part2)
        solution.part2
      else
        "Missing"
      end

      say "Part 1: #{part1_value}"
      say "Part 2: #{part2_value}"
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

    def in_year_directory?
      dir = root_path.basename.to_s
      dir =~ /^20[0-9]{2}/
    end
  end
end
