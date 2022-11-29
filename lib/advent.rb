# frozen_string_literal: true

require_relative "advent/configuration"
require_relative "advent/input"
require_relative "advent/session"
require_relative "advent/solution"
require_relative "advent/test_case"
require_relative "advent/version"

module Advent
  class Error < StandardError; end

  class << self
    def root
      if (location = find_config_location)
        location
      else
        raise Error, "Cannot find advent.yml config file in current or parent directories."
      end
    end

    def session
      @_session = Session.new
    end

    private

    def find_config_location
      Pathname.new(Dir.pwd).ascend do |path|
        return path if File.exist? path.join(Configuration::FILE_NAME)
        return nil if path.to_s == "/"
      end
    end
  end
end
