require "bundler/setup"
require "active_support/testing/autorun"
require "active_support/testing/stream"
require "debug"

require "advent"

class ActiveSupport::TestCase
  include ActiveSupport::Testing::Stream

  private
    def stdouted
      capture(:stdout) { yield }.strip
    end
end
