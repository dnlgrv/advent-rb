# frozen_string_literal: true

require "test_helper"

MockHTTP = Struct.new("MockHTTP") do
  def initialize
    @responses = {}
  end

  def add_response(url, cookie, body)
    @responses[url] = {body: body, cookie: cookie}
  end

  def get(uri, headers)
    if (response = @responses[uri.to_s]) && response[:cookie] == headers["Cookie"]
      response[:body]
    end
  end
end

class Advent::InputTest < Minitest::Test
  def setup
    @input = Advent::Input.new(DUMMY_ROOT_PATH.join("2015"), day: 3)

    @http_mock = MockHTTP.new
    @http_mock.add_response(
      "https://adventofcode.com/2015/day/3/input",
      "session=abc123; path=",
      "day 3 input"
    )
  end

  def test_exist?
    assert Advent::Input.new(DUMMY_ROOT_PATH.join("2015"), day: 1).exist?
    refute @input.exist?
  end

  def test_file_path
    assert_equal DUMMY_ROOT_PATH.join("2015", ".day3.input.txt"), @input.file_path
  end

  def test_download
    assert @input.download("abc123", @http_mock)
    assert_equal "day 3 input", File.read(@input.file_path)

    File.delete(@input.file_path)
  end
end
