require "test_helper"

class Advent::CliTest < ActiveSupport::TestCase
  test "solve with answers" do
    run_command("solve", "test/fixtures/day1.rb").tap do |output|
      assert_match %r{Part 1.*123}, output
      assert_match %r{Part 2.*456}, output
    end
  end
  
  test "solve without answers" do
    run_command("solve", "test/fixtures/day2.rb").tap do |output|
      assert_match %r{Part 1.*No answer}, output
      assert_match %r{Part 2.*No answer}, output
    end
  end

  test "version" do
    run_command("version").tap do |output|
      assert_equal Advent::VERSION, output
    end
  end
end
