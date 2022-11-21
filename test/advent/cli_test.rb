require "test_helper"

require "advent/cli"

class Advent::CLITest < Minitest::Test
  def setup
    @cli = Advent::CLI.new
  end

  def test_version
    out, _err = capture_io do
      @cli.invoke(:version)
    end

    assert_equal Advent::VERSION, out.strip
  end
end
