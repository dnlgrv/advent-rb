# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "advent"

require "minitest/autorun"

DUMMY_ROOT_PATH = Pathname.new File.expand_path("dummy", __dir__)

class MockHTTP
  def initialize
    @responses = {}
  end

  def add_response(url, cookie, body)
    @responses[url] = {body: body, cookie: cookie}
  end

  def get(uri, headers)
    if (response = @responses[uri.to_s]) && response[:cookie] == headers["Cookie"]
      response[:body]
    end
  end
end

class MockSTDIN < StringIO
  def noecho
    yield self
  end
end
