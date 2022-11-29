# frozen_string_literal: true

require "test_helper"

class Advent::ConfigurationTest < Advent::TestCase
  def setup
    @config_file = DUMMY_ROOT_PATH.join("advent.yml")
  end

  def test_initializing_with_defaults
    config = Advent::Configuration.new

    assert config.download_when_generating
    assert config.remember_session
  end

  def test_initializing_from_file
    config = Advent::Configuration.from_file(@config_file)

    refute config.download_when_generating
    assert config.remember_session
  end
end
