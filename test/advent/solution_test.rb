require "test_helper"

require_relative "../fixtures/day1"

class Advent::SolutionTest < ActiveSupport::TestCase
  test "input text" do
    assert_equal "day 1 input text", Day1.new.input_text.chomp
  end
end
