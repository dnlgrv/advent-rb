# frozen_string_literal: true

require "cgi/cookie"
require "net/http"
require "uri"

module Advent
  class Input
    def initialize(dir, day:)
      @dir = dir
      @day = day
    end

    def file_path
      @dir.join(".day#{@day}.input.txt")
    end

    def exist?
      File.exist? file_path
    end

    def download(session, http = Net::HTTP)
      session_cookie = CGI::Cookie.new("session", session)
      response = http.get(input_url, {"Cookie" => session_cookie.to_s})

      if response
        File.write(file_path, response)
        true
      else
        false
      end
    end

    private

    def input_url
      URI("https://adventofcode.com/#{year}/day/#{@day}/input")
    end

    def year
      @_year ||= @dir.basename
    end
  end
end
