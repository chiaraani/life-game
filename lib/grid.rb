# frozen_string_literal: true

# Grid of cells that die, live and reproduce
class Grid
  attr_reader :cells

  def initialize
    generate_cells
  end

  private

  def generate_cells
    # True means live cell. False means empty or dead.
    @cells = Array.new(50) { Array.new(50) { [true, false].sample } }
  end
end
