require "thor"

module Advent
  class Cli < Thor
    include Thor::Actions

    # EXCLUDED_ROOT_COMMANDS = %w[help init version]

    # def initialize(*args)
    #   super

      # source_paths << File.expand_path("templates", __dir__)

      # # Don't try to load Advent.root if we're a command that doesn't need it
      # unless EXCLUDED_ROOT_COMMANDS.include? args.last[:current_command]&.name
      #   self.destination_root = Advent.root
      # end
    # end

    def self.exit_on_failure?
      true
    end

    # desc "download YEAR DAY", "Download the input for YEAR and DAY"
    # def download(year, day)
    #   Dir.chdir Advent.root do
    #     Downloader.new(self, year, day).download
    #   end
    # end

    # desc "generate YEAR DAY", "Generate a new solution for YEAR and DAY"
    # def generate(year, day)
    #   year = parse_number year
    #   day = parse_number day

    #   if (message = validate(year, day))
    #     say_error message, :red
    #     return
    #   end

    #   template "solution.rb.tt", "#{year}/day#{day}.rb", context: binding
    #   template "solution_test.rb.tt", "#{year}/test/day#{day}_test.rb", context: binding

    #   download year, day if Advent.config.download_when_generating
    # end

    # desc "init DIR", "Initialise a new advent project in DIR"
    # def init(dir = ".")
    #   create_file Pathname.getwd.join(dir).join(Advent::Configuration::FILE_NAME) do
    #     ""
    #   end
    # end

    desc "solve FILE", "solve your solution"
    def solve(path)
      load path

      require "active_support/core_ext/object/blank"
      require "active_support/core_ext/string/inflections"
      require "pathname"
      klass = Pathname.new(path).basename(".rb").to_s.classify.constantize

      part_1 = klass.new.part_1
      part_2 = klass.new.part_2

      say_status "Part 1", part_1.presence || "No answer", part_1.present? ? :green : :red
      say_status "Part 2", part_2.presence || "No answer", part_2.present? ? :green : :red
    end

    desc "version", "current gem version"
    def version
      say Advent::VERSION
    end
  end
end
