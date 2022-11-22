# frozen_string_literal: true

require "test_helper"

class Advent::InputTest < Minitest::Test
  def setup
    @input = Advent::Input.new(DUMMY_ROOT_PATH.join("2015"), day: 1)
  end

  def test_exist?
    assert @input.exist?
    refute Advent::Input.new(DUMMY_ROOT_PATH.join("2015"), day: 2).exist?
  end

  def test_file_path
    assert_equal DUMMY_ROOT_PATH.join("2015", ".day1.input.txt"), @input.file_path
  end
end
