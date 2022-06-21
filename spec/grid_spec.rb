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

  describe 'print' do
    it 'prints live cells as ⦿ and dead as a space' do
      output = grid.cells.map do |row|
        "#{Rainbow(row.map { |cell| cell ? '⦿' : ' ' }.join)
          .indianred.bright}\n"
      end.join

      expect { grid.print }.to output(output).to_stdout
    end
  end
end
