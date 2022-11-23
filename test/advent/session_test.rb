require "test_helper"

class Advent::SessionTest < Advent::TestCase
  def setup
    @session = Advent::Session.new(name)
  end

  def teardown
    @session.clear
  end

  def test_clear
    FileUtils.touch @session.file_name
    @session.clear
    refute File.exist? @session.file_name
  end

  def test_exist
    refute @session.exist?
    FileUtils.touch @session.file_name
    assert @session.exist?
  end

  def test_setting_value
    @session.value = "session value"
    assert_equal "session value", File.read(@session.file_name)
  end

  def test_value
    assert_nil @session.value
    File.write @session.file_name, "another session value"
    assert_equal "another session value", @session.value
  end
end
