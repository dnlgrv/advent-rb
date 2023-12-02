require "active_support"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module Advent
  class Error < StandardError; end
end

loader.eager_load
