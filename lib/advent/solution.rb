# frozen_string_literal: true

require "pathname"

module Advent
  class Solution
    attr_reader :year, :day

    def initialize
      year, day = infer_year_and_day_from_file_system

      @year = year
      @day = day
    end

    def load_input
      dir = source_location.dirname
      File.read(dir.join(".day#{@day}.input.txt"))
    end

    private

    def infer_year_and_day_from_file_system
      path, day = source_location.split

      day = /day([0-9]+)/.match(day.to_s)[1]
      year = path.basename.to_s

      [year, day].map(&:to_i)
    rescue
      raise Error, "Failed to infer year/day of solution."
    end

    def source_location
      class_path, _ = Object.const_source_location(self.class.to_s)
      Pathname.new(class_path)
    end
  end
end
