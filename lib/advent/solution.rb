class Advent::Solution
  def input_text
    require "pathname"

    location, _ = Object.const_source_location(self.class.to_s)
    path = Pathname.new(location)

    path.dirname.join(".#{path.basename(".rb")}_input.txt").read
  end
end
