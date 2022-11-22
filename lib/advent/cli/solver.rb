# frozen_string_literal: true

class Advent::CLI::Solver
  PARTS = [1, 2]

  module Solutions
  end

  def initialize(command, path)
    @command = command
    @path = path
  end

  def solve
    load @path, Solutions
    solution = Solutions.const_get(solution_class_name).new

    PARTS.each do |n|
      method_name = "part#{n}".to_sym

      result, colour = if solution.respond_to?(method_name)
        [solution.public_send(method_name), :green]
      end

      result, colour = ["Missing", :red] if result.nil?

      @command.say "Part #{n}: #{result}", colour, true
    end
  end

  private

  def day
    @_day ||= @path.basename.to_s.match(/day([0-9]+)\.rb/)[1]
  end

  def solution_file_name
    "day#{day}.rb"
  end

  def solution_class_name
    "Day#{day}"
  end
end
