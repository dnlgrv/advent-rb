require "date"
require "net/http"
require "pathname"
require "thor"

module Advent
  class Cli < Thor
    include Thor::Actions
    EXCLUDED_ROOT_COMMANDS = %w[help init version]

    class_option :http_module, default: Net::HTTP, check_default_type: false

    def initialize(*args)
      super

      source_paths << File.expand_path("templates", __dir__)

      # Don't try to load Advent.root if we're a command that doesn't need it
      unless EXCLUDED_ROOT_COMMANDS.include? args.last[:current_command]&.name
        self.destination_root = Advent.root
      end
    end

    # @return [Boolean] defines whether an exit status is set if a command fails
    def self.exit_on_failure?
      true
    end

    desc "download YEAR DAY", "Download the input for YEAR and DAY"
    def download(year, day)
      require "advent/cli/downloader"

      Dir.chdir Advent.root do
        Downloader.new(self, year, day).download
      end
    end

    desc "generate YEAR DAY", "Generate a new solution for YEAR and DAY"
    # Generates a new solution file. If within a year directory, only the day
    # is used, otherwise both the year and day will be required to generate the
    # output.
    def generate(year, day)
      year = parse_number year
      day = parse_number day

      if (message = validate(year, day))
        say_error message, :red
        return
      end

      template "solution.rb.tt", "#{year}/day#{day}.rb", context: binding
      template "solution_test.rb.tt", "#{year}/test/day#{day}_test.rb", context: binding

      download year, day if Advent.config.download_when_generating
    end

    desc "init DIR", "Initialise a new advent project in DIR"
    def init(dir = ".")
      create_file Pathname.getwd.join(dir).join(Advent::Configuration::FILE_NAME) do
        ""
      end
    end

    desc "solve FILE", "Solve your solution"
    # Runs a solution file, outputting both :part1 and :part2 method return values.
    def solve(path)
      require "advent/cli/solver"
      file_path = Pathname.getwd.join(path)

      Dir.chdir Advent.root do
        Solver.new(self, file_path.relative_path_from(Advent.root)).solve
      end
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
