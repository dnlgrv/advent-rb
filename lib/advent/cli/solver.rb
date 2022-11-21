class Advent::CLI::Solver
  PARTS = [1, 2]

  def initialize(command, root_path:, year:, day:)
    @command = command
    @root_path = root_path
    @year = year
    @day = day
  end

  def solve
    if in_year_directory?
      require @root_path.join(solution_file_name).to_s
    else
      require @root_path.join(@year.to_s, solution_file_name)
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

  def in_year_directory?
    dir = @root_path.basename.to_s
    dir =~ /^20[0-9]{2}/
  end
end
