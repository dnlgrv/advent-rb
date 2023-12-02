require "cgi/cookie"
require "fileutils"
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

    def download(session, command)
      session_cookie = CGI::Cookie.new("session", session)
      command.get input_url, file_path, http_headers: {"Cookie" => session_cookie.to_s}
    end

    private

    def input_url
      "https://adventofcode.com/#{year}/day/#{@day}/input"
    end

    def year
      @_year ||= @dir.basename
    end

    def success?(response)
      response.code >= "200" && response.code < "300"
    end
  end
end
