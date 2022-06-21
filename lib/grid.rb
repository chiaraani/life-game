# frozen_string_literal: true

require 'rainbow'

# Grid of cells that die, live and reproduce
class Grid
  attr_reader :cells

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    generate_cells
  end

  def print
    system 'clear'

    @cells.each do |row|
      line = row.map { |cell| cell ? '⦿' : ' ' }.join
      puts Rainbow(line).indianred.bright
    end
  end

  private

  def generate_cells
    # True means live cell. False means empty or dead.
    @cells = Array.new(@rows) { Array.new(@columns) { [true, false].sample } }
  end
end
