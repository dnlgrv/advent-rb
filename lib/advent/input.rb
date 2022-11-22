# frozen_string_literal: true

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
  end
end
