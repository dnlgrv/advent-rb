require "bundler/setup"
require "active_support/testing/autorun"
require "active_support/testing/stream"
require "mocha/minitest"
require "minitest/autorun"
require "debug"

require "advent"

class ActiveSupport::TestCase
  include ActiveSupport::Testing::Stream

  private
    def run_command(*command)
      stdouted { Advent::Cli.start [*command] }
    end

    def stdouted
      capture(:stdout) { yield }.strip
    end
end
