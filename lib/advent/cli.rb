require "thor"

class Advent::Cli < Thor
  include Thor::Actions

  def self.exit_on_failure?
    true
  end

  desc "auth", "remember your session for downloading inputs"
  option :session, aliases: "-s", type: :string, default: nil, desc: "Provide the value directly without being prompted"
  def auth
    session = options[:session] || ask("What is your Advent of Code session value?", echo: false)
    say ""

    create_file ".advent_session", session
    append_to_file ".gitignore", ".advent_session" if File.exist? ".git"
  end

  desc "download YEAR DAY", "download input"
  def download(year, day)
    get "https://adventofcode.com/#{year}/day/#{day}/input", "#{year}/.day#{day}_input.txt", http_headers: http_headers
  end

  desc "new YEAR DAY", "start a new solution"
  def new(year, day)
    self.class.source_root __dir__

    template "templates/solution.rb.tt", "#{year}/day#{day}.rb", context: binding
    template "templates/solution_test.rb.tt", "test/#{year}/day#{day}_test.rb", context: binding
  end

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

  private
    def http_headers
      {"Cookie" => CGI::Cookie.new("session", session).to_s}
    end

    def session
      File.read(".advent_session").chomp
    end
end
