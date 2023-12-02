require "test_helper"

class Advent::CliTest < ActiveSupport::TestCase
  test "auth with session" do
    run_command("auth", "-s", "value").tap do |output|
      refute_match "What is your Advent of Code session value?", output
      
      assert_match /create.*\.advent_session/, output
      assert_match /\.advent_session/, File.read(".gitignore")
      assert_equal "value", File.read(".advent_session")
    end
  ensure
    gitignore = File.read(".gitignore")
    without_session = gitignore.lines.select { _1 != ".advent_session" }
    File.open(".gitignore", "w") { _1.puts without_session }
    File.delete ".advent_session" if File.exist? ".advent_session"
  end

  test "solving with answers" do
    run_command("solve", "test/fixtures/day1.rb").tap do |output|
      assert_match %r{Part 1.*123}, output
      assert_match %r{Part 2.*456}, output
    end
  end
  
  test "solving without answers" do
    run_command("solve", "test/fixtures/day2.rb").tap do |output|
      assert_match %r{Part 1.*No answer}, output
      assert_match %r{Part 2.*No answer}, output
    end
  end

  test "starting a new day" do
    run_command("new", "2023", "1")

    assert_match "class Day1", File.read("2023/day1.rb")
    assert_match "class Day1Test", File.read("test/2023/day1_test.rb")
  ensure
    File.delete "2023/day1.rb" if File.exist? "2023/day1.rb"
    File.delete "test/2023/day1_test.rb" if File.exist? "test/2023/day1_test.rb"
  end

  test "version" do
    run_command("version").tap do |output|
      assert_equal Advent::VERSION, output
    end
  end
end
