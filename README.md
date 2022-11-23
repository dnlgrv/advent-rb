# Advent

[![Gem Version](https://badge.fury.io/rb/advent.svg)](https://badge.fury.io/rb/advent)

Have fun with the [Advent of Code](https://rubygems.org) using Ruby.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add advent

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install advent

## Usage

Advent expects you to have a working directory resembling something like:

    $ tree
    .
    ├── 2015
    └── 2016

Some commands can be run from within a directory for a specific year, but it's
better to run from the parent directory where possible.

The typical flow for tackling a daily challenge would be:

    $ advent generate 2015 1 # generate files to work in
    $ advent download 2015 1 # download the input file

    $ vim 2015/day1.rb 2015/day1_test.rb # do your work

    $ ruby 2015/day1_test.rb # run any tests you may have
    $ advent solve 2015/day1.rb # get your answers to submit

A list of commands and help is available using `advent`:

    $ advent help

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dnlgrv/advent-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
