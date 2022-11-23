# frozen_string_literal: true

require "cgi/cookie"
require "fileutils"
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
      response = http.get_response(input_url, {"Cookie" => session_cookie.to_s})

      if success?(response)
        FileUtils.mkdir_p file_path.dirname
        File.write file_path, response.body
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

    def success?(response)
      response.code >= "200" && response.code < "300"
    end
  end
end
