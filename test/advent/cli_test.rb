require "test_helper"

class Advent::CliTest < ActiveSupport::TestCase
  test "version" do
    run_command("version").tap do |output|
      assert_equal Advent::VERSION, output
    end
  end

  private
    def run_command(*command)
      stdouted { Advent::Cli.start [*command] }
    end
end
