# frozen_string_literal: true

require 'rainbow'

# Grid of cells that die, live and reproduce
class Grid
  attr_accessor :cells

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

  def neighbours_coordinates_of(row, column)
    neighbours = []
    (row - 1..row + 1).each do |neighbour_row|
      (column - 1..column + 1).each do |neighbour_column|
        next unless (0..@rows - 1).include? neighbour_row
        next unless (0..@columns - 1).include? neighbour_column
        next if neighbour_row == row && neighbour_column == column

        neighbours << [neighbour_row, neighbour_column]
      end
    end
    neighbours
  end

  def next?(row, column)
    cell = @cells[row][column]
    neighbour_count = live_neighbour_count_of(row, column)

    if cell
      neighbour_count > 1 && neighbour_count < 4
    else
      neighbour_count == 3
    end
  end

  private

  def generate_cells
    # True means live cell. False means empty or dead.
    @cells = Array.new(@rows) { Array.new(@columns) { [true, false].sample } }
  end

  def live_neighbour_count_of(row, column)
    neighbours_coordinates_of(row, column).count do |neighbour|
      @cells[neighbour[0]][neighbour[1]]
    end
  end
end
