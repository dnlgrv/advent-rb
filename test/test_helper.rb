require "bundler/setup"
require "minitest/autorun"
require "debug"

require "advent"

DUMMY_ROOT_PATH = Pathname.new File.expand_path("dummy", __dir__)

class Advent::TestCase < Minitest::Test
  def with_config(config)
    original_config = Advent.config

    config_with_defaults = Advent::Configuration::DEFAULTS.merge(config)
    Advent.instance_variable_set(:@_config, Advent::Configuration.new(config_with_defaults))

    yield
  ensure
    Advent.instance_variable_set(:@_config, original_config)
  end

  def with_session(value)
    Advent.session.value = value
    yield
  ensure
    Advent.session.clear
  end

  def with_stdin_input(input)
    require "stringio"

    io = MockSTDIN.new
    io.puts input
    io.rewind

    real_stdin, $stdin = $stdin, io
    yield
  ensure
    $stdin = real_stdin
  end

  def with_readline_input(input)
    require "readline"

    input_file_name = "#{name}.input"

    f = File.open(input_file_name, "w+")
    f.write input
    f.rewind

    ::Readline.input = f
    yield
  ensure
    f.close
    File.delete input_file_name
  end
end

class MockHTTP
  MockResponse = Struct.new(:code, :body)

  def initialize
    @responses = {}
  end

  def add_response(url, cookie, body)
    @responses[url] = {body: body, cookie: cookie}
  end

  def get_response(uri, headers)
    if (response = @responses[uri.to_s]) && response[:cookie] == headers["Cookie"]
      MockResponse.new("200", response[:body])
    else
      MockResponse.new("400", nil)
    end
  end
end

class MockSTDIN < StringIO
  def noecho
    yield self
  end
end
