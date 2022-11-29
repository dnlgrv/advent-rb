# frozen_string_literal: true

class Advent::CLI::Downloader
  def initialize(command, year, day)
    @command = command
    @year = year
    @day = day
  end

  def download
    ask_for_session_cookie_if_needed
    input = Advent::Input.new(Advent.root.join(@year), day: @day.to_i)

    if input.download(Advent.session.value, @command.options.http_module)
      @command.say "Input downloaded to #{input.file_path}.", :green
      @command.say "\nUsing #load_input in your daily solution will load the input file for you."
    else
      @command.say_error "Something went wrong, maybe an old session cookie?", :red
    end
  end

  private

  def ask_for_session_cookie_if_needed
    return if Advent.session.exist?

    session = @command.ask "What is your Advent of Code session cookie value?", echo: false
    Advent.session.value = session

    @command.say "\n\nThanks. Psst, we're going to save this for next time. It's in .advent_session if you need to update or delete it.\n\n"
  end
end
