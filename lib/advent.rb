require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module Advent
  class Error < StandardError; end

  class << self
    def config
      @_config ||= Configuration.from_file(root.join(Configuration::FILE_NAME))
    end

    def root
      if (location = find_config_location)
        location
      else
        raise Error, "Cannot find advent.yml config file in current or parent directories."
      end
    end

    def session
      @_session ||= Session.new
    end

    private

    def find_config_location
      Pathname.new(Dir.pwd).ascend do |path|
        return path if File.exist? path.join(Configuration::FILE_NAME)
        return nil if path.to_s == "/"
      end
    end
  end
end

loader.eager_load
