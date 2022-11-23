module Advent
  # Simple class for handling the session cookie file
  class Session
    FILE_NAME = ".advent_session"

    attr_reader :file_name

    def initialize(file_name = FILE_NAME)
      @file_name = file_name
    end

    def clear
      File.delete file_name if exist?
    end

    def exist?
      File.exist? file_name
    end

    def value=(val)
      File.write file_name, val
    end

    def value
      File.read file_name if exist?
    end
  end
end
