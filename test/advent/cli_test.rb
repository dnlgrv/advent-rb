# frozen_string_literal: true

require "test_helper"

require "advent/cli"
require "date"

class Advent::CLITest < Advent::TestCase
  def setup
    @session = "abc123"

    http_mock = MockHTTP.new
    http_mock.add_response(
      "https://adventofcode.com/2015/day/3/input",
      "session=#{@session}; path=",
      "day 3 input"
    )

    @cli = Advent::CLI.new([], root_path: DUMMY_ROOT_PATH, http_module: http_mock)
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

  def test_generate_solution_with_non_numbers_in_day
    capture_io do
      @year_cli.invoke(:generate, ["day3"])
    end

    ["day3.rb", "test/day3_test.rb"].each do |file_name|
      expected_file_path = DUMMY_ROOT_PATH.join("2015", file_name)
      assert File.exist? expected_file_path

      File.delete expected_file_path
    end
  end

  def test_generate_solution_valid_minimum_year
    _out, err = capture_io do
      @cli.invoke(:generate, ["2013", "1"])
    end

    assert_equal "Advent of Code only started in 2014!", err.strip
  end

  def test_generate_solution_valid_maximum_year
    _out, err = capture_io do
      @cli.invoke(:generate, [Date.today.year + 1, "1"])
    end

    assert_equal "Future years are not supported.", err.strip
  end

  def test_generate_solution_valid_minimum_day
    _out, err = capture_io do
      @cli.invoke(:generate, ["2015", "0"])
    end

    assert_equal "Day must be between 1 and 25 (inclusive).", err.strip
  end

  def test_generate_solution_valid_maximum_day
    _out, err = capture_io do
      @cli.invoke(:generate, ["2015", "26"])
    end

    assert_equal "Day must be between 1 and 25 (inclusive).", err.strip
  end

  def test_download_input
    out, _err = capture_io do
      with_stdin_input(@session) do
        @cli.invoke(:download, ["2015", "3"])
      end
    end

    input_path = DUMMY_ROOT_PATH.join("2015", ".day3.input.txt")
    assert File.exist?(input_path)
    assert_equal "day 3 input", File.read(input_path)
    assert_match(/Input downloaded to #{input_path}/, out.strip)
  ensure
    File.delete input_path
  end

  def test_download_input_failure
    _out, err = capture_io do
      with_stdin_input("invalid") do
        @cli.invoke(:download, ["2015", "3"])
      end
    end

    input_path = DUMMY_ROOT_PATH.join("2015", ".day3.input.txt")
    refute File.exist?(input_path)
    assert_match(/Something went wrong/, err.strip)
  end
end
