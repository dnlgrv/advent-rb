require "test_helper"

class Advent::InputTest < Advent::TestCase
  def setup
    @input = Advent::Input.new(DUMMY_ROOT_PATH.join("2015"), day: 10)

    @http_mock = MockHTTP.new
    @http_mock.add_response(
      "https://adventofcode.com/2015/day/10/input",
      "session=abc123; path=",
      "day 10 input"
    )
  end

  def test_exist?
    assert Advent::Input.new(DUMMY_ROOT_PATH.join("2015"), day: 1).exist?
    refute @input.exist?
  end

  def test_file_path
    assert_equal DUMMY_ROOT_PATH.join("2015", ".day10.input.txt"), @input.file_path
  end

  def test_download
    assert @input.download("abc123", @http_mock)
    assert_equal "day 10 input", File.read(@input.file_path)
  ensure
    File.delete(@input.file_path) if @input.exist?
  end
end
