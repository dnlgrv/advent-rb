# frozen_string_literal: true

require_relative "advent/configuration"
require_relative "advent/input"
require_relative "advent/session"
require_relative "advent/solution"
require_relative "advent/test_case"
require_relative "advent/version"

module Advent
  class Error < StandardError; end

  class << self
    def session
      @_session = Session.new
    end
  end
end
