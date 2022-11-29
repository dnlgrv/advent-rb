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
      if save_to_disk?
        File.write file_name, val
      else
        @_value = val
      end
    end

    def value
      return @_value unless save_to_disk?
      return File.read(file_name) if exist?
    end

    private

    def save_to_disk?
      Advent.config.remember_session
    end
  end
end
