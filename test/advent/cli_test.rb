# frozen_string_literal: true

require "test_helper"

require "advent/cli"

class Advent::CLITest < Minitest::Test
  def setup
    @cli = Advent::CLI.new([], root_path: DUMMY_ROOT_PATH)
    @year_cli = Advent::CLI.new([], root_path: DUMMY_ROOT_PATH.join("2015"))
  end

  def test_version
    out, _err = capture_io do
      @cli.invoke(:version)
    end

    assert_equal Advent::VERSION, out.strip
  end

  def test_solve_from_parent_directory
    out, _err = capture_io do
      @cli.invoke(:solve, ["2015/day1.rb"])
    end

    assert_equal "Part 1: 123\nPart 2: 456", out.strip
  end

  def test_solve_from_year_directory
    out, _err = capture_io do
      @year_cli.invoke(:solve, ["day2.rb"])
    end

    assert_equal "Part 1: 789\nPart 2: Missing", out.strip
  end

  def test_generate_solution_with_year_and_day
    capture_io do
      @cli.invoke(:generate, ["2015", "3"])
    end

    ["day3.rb", "test/day3_test.rb"].each do |file_name|
      expected_file_path = DUMMY_ROOT_PATH.join("2015", file_name)
      assert File.exist? expected_file_path

      File.delete expected_file_path
    end
  end

  def test_generate_solution_from_year_directory_with_day
    capture_io do
      @year_cli.invoke(:generate, ["3"])
    end

    ["day3.rb", "test/day3_test.rb"].each do |file_name|
      expected_file_path = DUMMY_ROOT_PATH.join("2015", file_name)
      assert File.exist? expected_file_path

      File.delete expected_file_path
    end
  end
end
