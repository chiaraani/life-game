# frozen_string_literal: true

require 'rainbow'

# Grid of cells that die, live and reproduce
class Grid
  class << self
    attr_accessor :config

    @config = { default: { rows: 50, columns: 50, phase_duration: 1, phases: 10 } }
  end

  attr_accessor :cells, :phase

  def initialize(**args)
    args.merge(Grid.config[:default], args).each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
    generate_cells
  end

  def print
    system 'clear'

    @cells.each do |row|
      line = row.map { |cell| cell ? '⦿' : ' ' }.join
      puts Rainbow(line).indianred.bright
    end

    puts "Phase #{@phase}"
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

  def next_phase
    next_cells = (0..@rows - 1).map do |row|
      (0..@columns - 1).map { |column| next? row, column }
    end
    @cells = next_cells
    @phase += 1
  end

  private

  def generate_cells
    # True means live cell. False means empty or dead.
    @cells = Array.new(@rows) { Array.new(@columns) { [true, false].sample } }
    @phase = 0
  end

  def live_neighbour_count_of(row, column)
    neighbours_coordinates_of(row, column).count do |neighbour|
      @cells[neighbour[0]][neighbour[1]]
    end
  end
end
