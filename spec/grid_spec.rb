# frozen_string_literal: true

require 'rspec'
require 'rainbow'
require_relative '../lib/grid'

RSpec.describe Grid do
  rows = 10
  columns = 5

  subject(:grid) { described_class.new(rows, columns) }

  describe 'cells' do
    it "has #{rows} rows" do
      expect(grid.cells.count).to equal rows
    end

    it "has #{columns} columns" do
      expect(grid.cells.all? { |row| row.count == columns }).to be true
    end

    it 'are either true or false' do
      expect(
        grid.cells.all? do |row|
          row.all? { |cell| [true, false].include? cell }
        end
      ).to be true
    end
  end

  describe '#print' do
    it 'prints live cells as ⦿ and dead as a space' do
      output = grid.cells.map do |row|
        "#{Rainbow(row.map { |cell| cell ? '⦿' : ' ' }.join)
          .indianred.bright}\n"
      end.join

      expect { grid.print }.to output(output).to_stdout
    end
  end

  describe '#neighbours_of' do
    shared_examples 'neighbours of' do |cell, neighbours|
      it 'returns coordinates of neighbours' do
        expect(grid.neighbours_of(*cell)).to match(neighbours.sort)
      end
    end

    context 'with internal coordinates' do
      include_examples 'neighbours of', [1, 1],
        [[0, 0], [0, 1], [0, 2], [1, 0], [1, 2], [2, 0], [2, 1], [2, 2]]
    end

    context 'with corner coordinates' do
      include_examples 'neighbours of', [0, 0],
        [[0, 1], [1, 0], [1, 1]]

      include_examples 'neighbours of', [rows - 1, 0],
        [[rows - 1, 1], [rows - 2, 0], [rows - 2, 1]]

      include_examples 'neighbours of', [0, columns - 1],
        [[0, columns - 2], [1, columns - 1], [1, columns - 2]]

      include_examples 'neighbours of', [rows - 1, columns - 1],
        [[rows - 1, columns - 2], [rows - 2, columns - 1], [rows - 2, columns - 2]]
    end

    context 'with edge coordinates' do
      include_examples 'neighbours of', [0, 1],
        [[0, 0], [0, 2], [1, 0], [1, 1], [1, 2]]

      include_examples 'neighbours of', [1, 0],
        [[0, 0], [0, 1], [1, 1], [2, 1], [2, 0]]

      include_examples 'neighbours of', [rows - 1, 1],
        [[rows - 1, 0], [rows - 1, 2], [rows - 2, 0], [rows - 2, 1], [rows - 2, 2]]

      include_examples 'neighbours of', [1, columns - 1],
        [[0, columns - 1], [0, columns - 2], [1, columns - 2], [2, columns - 1], [2, columns - 2]]
    end
  end

  #   describe 'next?' do
  #     context 'without neighbours' do
  #       it 'dies' do
  #         grid.cells[0] = [false, false, false, true, false]
  #         grid.cells[1] = [false, true, false, false, true]
  #         grid.cells[3] = [false, false, false, true, true]
  #
  #         expect(grid.next?(1, 1)).to be false
  #       end
  #     end
  #
  #     context 'with one neighbour' do
  #       it 'dies' do
  #         grid.cells[0] = [true, false, false, true, false]
  #         grid.cells[1] = [false, true, false, false, true]
  #         grid.cells[3] = [false, false, false, true, true]
  #
  #         expect(grid.next?(1, 1)).to be false
  #       end
  #     end
  #
  #     context 'with two neighbours' do
  #       it 'lives' do
  #         grid.cells[0] = [true, false, false, true, false]
  #         grid.cells[1] = [false, true, false, false, true]
  #         grid.cells[3] = [true, false, false, true, true]
  #
  #         expect(grid.next?(1, 1)).to be true
  #       end
  #     end
  #
  #     context 'with three neighbours' do
  #       it 'lives' do
  #         grid.cells[0] = [true, false, false, true, false]
  #         grid.cells[1] = [false, true, true, false, true]
  #         grid.cells[3] = [true, false, false, true, true]
  #
  #         expect(grid.next?(1, 1)).to be true
  #       end
  #     end
  #
  #     context 'with four neighbours' do
  #       it 'dies' do
  #         grid.cells[0] = [true, true, true, true, false]
  #         grid.cells[1] = [false, true, false, false, true]
  #         grid.cells[3] = [true, false, false, true, true]
  #
  #         expect(grid.next?(1, 1)).to be false
  #       end
  #     end
  #
  #     context 'with five neighbours' do
  #       it 'dies' do
  #         grid.cells[0] = [true, true, true, true, false]
  #         grid.cells[1] = [true, true, false, false, true]
  #         grid.cells[3] = [true, false, false, true, true]
  #
  #         expect(grid.next?(1, 1)).to be false
  #       end
  #     end
  #
  #     context 'with three neighbours and empty' do
  #       it 'is born' do
  #         grid.cells[0] = [false, true, true, true, false]
  #         grid.cells[1] = [false, false, false, false, true]
  #         grid.cells[3] = [true, false, false, true, true]
  #
  #         expect(grid.next?(1, 1)).to be true
  #       end
  #     end
  #
  #     context 'with two neighbours and empty' do
  #       it 'is empty' do
  #         grid.cells[0] = [false, true, true, true, false]
  #         grid.cells[1] = [false, false, false, false, true]
  #         grid.cells[3] = [true, false, false, true, true]
  #
  #         expect(grid.next?(1, 1)).to be false
  #       end
  #     end
  #
  #     context 'with two neighbours at the corner' do
  #       it 'lives' do
  #         grid.cells[0] = [true, true, false, true, false]
  #         grid.cells[1] = [false, true, false, false, true]
  #
  #         expect(grid.next?(0, 0)).to be true
  #       end
  #     end
  #   end
end
