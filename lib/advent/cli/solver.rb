# frozen_string_literal: true

class Advent::CLI::Solver
  PARTS = [1, 2]

  def initialize(command, year:, day:)
    @command = command
    @year = year
    @day = day
  end

  def solve
    if @command.in_year_directory?
      require @command.root_path.join(solution_file_name).to_s
    else
      require @command.root_path.join(@year.to_s, solution_file_name)
    end

    solution = Object.const_get(solution_class_name).new

    PARTS.each do |n|
      method_name = "part#{n}".to_sym
      result = if solution.respond_to?(method_name)
        solution.public_send(method_name)
      else
        "Missing"
      end

      @command.say "Part #{n}: #{result}"
    end
  end

  private

  def solution_file_name
    "day#{@day}.rb"
  end

  def solution_class_name
    "Day#{@day}"
  end
end
