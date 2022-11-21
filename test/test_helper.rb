# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "advent"

require "minitest/autorun"

DUMMY_ROOT_PATH = Pathname.new File.expand_path("dummy", __dir__)
