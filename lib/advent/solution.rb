# frozen_string_literal: true

require "pathname"

module Advent
  # Baes class for an Advent of Code solution attempt. If subclass is in a
  # directory matching a year (eg. 2015) and the filename is for a particular
  # day (eg. day1.rb) then the @year and @day instance variables are
  # automatically inferred.
  class Solution
    attr_reader :year # @return [Numeric] the year this solution is from
    attr_reader :day # @return [Numeric] the day this solution is for

    def initialize
      year, day = infer_year_and_day_from_file_system

      @year = year
      @day = day

      @input = Input.new(source_location.dirname, day: day)
    end

    def load_input
      File.read(@input.file_path)
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
