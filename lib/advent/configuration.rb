require "psych"

module Advent
  class Configuration
    DEFAULTS = {
      "download_when_generating" => true,
      "remember_session" => true
    }
    FILE_NAME = "advent.yml"

    attr_reader :download_when_generating, :remember_session

    class << self
      def from_file(file = FILE_NAME)
        if RUBY_VERSION >= "3.1"
          new Psych.safe_load_file(file)
        else
          new Psych.safe_load(File.read(file))
        end
      end
    end

    def initialize(conf)
      config = DEFAULTS.merge(conf || {})

      @download_when_generating = config.dig("download_when_generating")
      @remember_session = config.dig("remember_session")
    end
  end
end
