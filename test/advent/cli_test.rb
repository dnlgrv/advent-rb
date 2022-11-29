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
    http_mock.add_response(
      "https://adventofcode.com/2015/day/4/input",
      "session=#{@session}; path=",
      "day 4 input"
    )
    http_mock.add_response(
      "https://adventofcode.com/2015/day/5/input",
      "session=#{@session}; path=",
      "day 5 input"
    )

    Dir.chdir DUMMY_ROOT_PATH
    @cli = Advent::CLI.new([], http_module: http_mock)
  end

  def teardown
    Dir.chdir DUMMY_ROOT_PATH
    Advent.session.clear
  end

  def test_version
    out, _err = capture_io do
      @cli.invoke(:version)
    end

    assert_equal Advent::VERSION, out.strip
  end

  def test_solve_from_root_directory
    out, _err = capture_io do
      @cli.invoke(:solve, ["2015/day1.rb"])
    end

    assert_equal "Part 1: 123\nPart 2: 456", out.strip
  end

  def test_solve_from_year_directory
    out, _err = capture_io do
      Dir.chdir DUMMY_ROOT_PATH.join("2015") do
        @cli.invoke(:solve, ["day2.rb"])
      end
    end

    assert_equal "Part 1: 789\nPart 2: Missing", out.strip
  end

  def test_generate
    capture_io do
      @cli.invoke(:generate, ["2015", "3"])
    end

    ["day3.rb", "test/day3_test.rb"].each do |file_name|
      expected_file_path = DUMMY_ROOT_PATH.join("2015", file_name)
      assert File.exist? expected_file_path

      File.delete expected_file_path
    end
  end

  def test_download_when_generating
    with_session("abc123") do
      with_config({"download_when_generating" => true}) do
        capture_io do
          @cli.invoke(:generate, ["2015", "3"])
        end
      end
    end

    assert File.exist? DUMMY_ROOT_PATH.join("2015", "day3.rb")
    assert File.exist? DUMMY_ROOT_PATH.join("2015", ".day3.input.txt")
    
    File.delete DUMMY_ROOT_PATH.join("2015", "day3.rb")
    File.delete DUMMY_ROOT_PATH.join("2015", "test", "day3_test.rb")
    File.delete DUMMY_ROOT_PATH.join("2015", ".day3.input.txt")
  end

  def test_generate_day_parsing
    capture_io do
      @cli.invoke(:generate, ["2015", "day3"])
    end

    ["day3.rb", "test/day3_test.rb"].each do |file_name|
      expected_file_path = DUMMY_ROOT_PATH.join("2015", file_name)
      assert File.exist? expected_file_path

      File.delete expected_file_path
    end
  end

  def test_generate_valid_minimum_year
    _out, err = capture_io do
      @cli.invoke(:generate, ["2013", "1"])
    end

    assert_equal "Advent of Code only started in 2014!", err.strip
  end

  def test_generate_valid_maximum_year
    _out, err = capture_io do
      @cli.invoke(:generate, [(Date.today.year + 1).to_s, "1"])
    end

    assert_equal "Future years are not supported.", err.strip
  end

  def test_generate_valid_minimum_day
    _out, err = capture_io do
      @cli.invoke(:generate, ["2015", "0"])
    end

    assert_equal "Day must be between 1 and 25 (inclusive).", err.strip
  end

  def test_generate_valid_maximum_day
    _out, err = capture_io do
      @cli.invoke(:generate, ["2015", "26"])
    end

    assert_equal "Day must be between 1 and 25 (inclusive).", err.strip
  end

  def test_download_from_root_directory
    out, _err = capture_io do
      with_session(@session) do
        @cli.invoke(:download, ["2015", "3"])
      end
    end

    input_path = DUMMY_ROOT_PATH.join("2015", ".day3.input.txt")
    assert File.exist?(input_path)
    assert_equal "day 3 input", File.read(input_path)
    assert_match(/Input downloaded to #{input_path}/, out.strip)
  ensure
    File.delete input_path if File.exist? input_path
  end

  def test_persisting_session_cookie
    with_stdin_input(@session) do
      capture_io do
        @cli.invoke(:download, ["2015", "4"])
      end
    end

    assert_equal @session, Advent.session.value
  ensure
    input = DUMMY_ROOT_PATH.join("2015", ".day4.input.txt")
    File.delete input if File.exist? input
  end

  def test_not_asking_for_session_cookie_again
    Advent.session.value = @session

    out, _err = capture_io do
      with_stdin_input("not needed") do
        @cli.invoke(:download, ["2015", "5"])
      end
    end

    refute_match(/session cookie value/, out)
  ensure
    input = DUMMY_ROOT_PATH.join("2015", ".day5.input.txt")
    File.delete input if File.exist? input
  end

  def test_download_error
    _out, err = capture_io do
      with_session("invalid") do
        @cli.invoke(:download, ["2015", "6"])
      end
    end

    assert_match(/Something went wrong/, err.strip)
  ensure
    input = DUMMY_ROOT_PATH.join("2015", ".day6.input.txt")
    File.delete input_path if File.exist? input
  end
end
