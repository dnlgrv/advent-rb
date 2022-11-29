# frozen_string_literal: true

require "test_helper"

class TestAdvent < Advent::TestCase
  def teardown
    Dir.chdir DUMMY_ROOT_PATH
  end

  def test_finding_root_from_config_location
    Dir.chdir DUMMY_ROOT_PATH do
      assert_equal DUMMY_ROOT_PATH, Advent.root
    end

    Dir.chdir DUMMY_ROOT_PATH.join("2015") do
      assert_equal DUMMY_ROOT_PATH, Advent.root
    end

    Dir.chdir DUMMY_ROOT_PATH.join("..") do
      error = assert_raises Advent::Error do
        Advent.root
      end

      assert_equal "Cannot find advent.yml config file in current or parent directories.", error.message
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::Advent::VERSION
  end
end
