require "pathname"

module Advent
  class Solution
    attr_reader :year, :day

    def initialize
      year, day = infer_year_and_day_from_file_system

      @year = year
      @day = day
    end

    private

    def infer_year_and_day_from_file_system
      class_path, _ = Object.const_source_location(self.class.to_s)
      class_path = Pathname.new(class_path)

      class_path, day = class_path.split
      day = /day([0-9]+)/.match(day.to_s)[1]
      year = class_path.basename.to_s

      [year, day].map(&:to_i)
    rescue
      raise Error, "Failed to infer year/day of solution."
    end
  end
end
