require "test_helper"

class Advent::SolutionTest < Advent::TestCase
  def setup
    require DUMMY_ROOT_PATH.join("2015", "day1.rb").to_s

    @solution = Day1.new
  end

  def test_initialize
    assert_equal 2015, @solution.year
    assert_equal 1, @solution.day
  end

  def test_initialize_failure
    assert require DUMMY_ROOT_PATH.join("no_year.rb").to_s
    assert require DUMMY_ROOT_PATH.join("2015", "no_day.rb").to_s

    assert_raises(Advent::Error, "Failed to infer year/day of solution") do
      NoYear.new
    end

    assert_raises(Advent::Error, "Failed to infer year/day of solution") do
      NoDay.new
    end
  end

  def test_load_input
    assert_equal "2015/day1 input", @solution.load_input.strip
  end
end
