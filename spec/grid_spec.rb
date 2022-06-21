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

  describe '#neighbours_coordinates_of' do
    shared_examples 'neighbours coordinates of' do |cell, neighbours|
      it 'returns coordinates of neighbours' do
        expect(grid.neighbours_coordinates_of(*cell)).to match(neighbours.sort)
      end
    end

    context 'with internal coordinates' do
      include_examples 'neighbours coordinates of', [1, 1],
        [[0, 0], [0, 1], [0, 2], [1, 0], [1, 2], [2, 0], [2, 1], [2, 2]]
    end

    context 'with corner coordinates' do
      include_examples 'neighbours coordinates of', [0, 0],
        [[0, 1], [1, 0], [1, 1]]

      include_examples 'neighbours coordinates of', [rows - 1, 0],
        [[rows - 1, 1], [rows - 2, 0], [rows - 2, 1]]

      include_examples 'neighbours coordinates of', [0, columns - 1],
        [[0, columns - 2], [1, columns - 1], [1, columns - 2]]

      include_examples 'neighbours coordinates of', [rows - 1, columns - 1],
        [[rows - 1, columns - 2], [rows - 2, columns - 1], [rows - 2, columns - 2]]
    end

    context 'with edge coordinates' do
      include_examples 'neighbours coordinates of', [0, 1],
        [[0, 0], [0, 2], [1, 0], [1, 1], [1, 2]]

      include_examples 'neighbours coordinates of', [1, 0],
        [[0, 0], [0, 1], [1, 1], [2, 1], [2, 0]]

      include_examples 'neighbours coordinates of', [rows - 1, 1],
        [[rows - 1, 0], [rows - 1, 2], [rows - 2, 0], [rows - 2, 1], [rows - 2, 2]]

      include_examples 'neighbours coordinates of', [1, columns - 1],
        [[0, columns - 1], [0, columns - 2], [1, columns - 2], [2, columns - 1], [2, columns - 2]]
    end
  end

  describe '#next?' do
    let(:rows) { 3 }
    let(:columns) { 5 }

    shared_examples 'next' do |description, cells, will_live|
      it description do
        grid.cells = cells
        expect(grid.next?(1, 1)).to match(will_live)
      end
    end

    context 'without neighbours' do
      include_examples 'next', 'dies',
        [
          [false, false, false, true, false],
          [false, true, false, false, true],
          [false, false, false, true, true]
        ], false
    end

    context 'with one neighbour' do
      include_examples 'next', 'dies',
        [
          [false, false, true, true, false],
          [false, true, false, false, true],
          [false, false, false, true, true]
        ], false
    end

    context 'with two neighbours' do
      include_examples 'next', 'lives',
        [
          [false, false, true, true, false],
          [true, true, false, false, true],
          [false, false, false, true, true]
        ], true
    end

    context 'with three neighbours' do
      include_examples 'next', 'lives',
        [
          [false, false, true, true, false],
          [true, true, true, false, true],
          [false, false, false, true, true]
        ], true
    end

    context 'with four neighbours' do
      include_examples 'next', 'dies',
        [
          [false, true, true, true, false],
          [true, true, true, false, true],
          [false, false, false, true, true]
        ], false
    end

    context 'with five neighbours' do
      include_examples 'next', 'dies',
        [
          [false, true, true, true, false],
          [true, true, true, false, true],
          [false, true, false, true, true]
        ], false
    end

    context 'with three neighbours and empty' do
      include_examples 'next', 'is born',
        [
          [false, false, true, true, false],
          [true, false, false, false, true],
          [false, true, false, true, true]
        ], true
    end

    context 'with two neighbours and empty' do
      include_examples 'next', 'is not born',
        [
          [false, false, false, true, false],
          [true, false, false, false, true],
          [false, true, false, true, true]
        ], false
    end
  end

  describe '#next_phase' do
    let(:phase0) do
      [
        [false, false, false, true, false],
        [true, false, false, false, true],
        [false, true, false, true, true],
        [true, false, false, true, false],
        [true, true, false, true, false]
      ]
    end

    let(:phase1) do
      [
        [false, false, false, false, false],
        [false, false, true, false, true],
        [true, true, true, true, true],
        [true, false, false, true, false],
        [true, true, true, false, false]
      ]
    end

    it 'adds 1 to phase variable' do
      expect { grid.next_phase }.to change(grid, :phase).by(1)
    end

    it 'changes cells to next phase' do
      rows = 5
      columns = 5
      grid.cells = phase0
      grid.next_phase
      expect(grid.cells).to(match(phase1))
    end
  end
end
