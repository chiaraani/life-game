# frozen_string_literal: true

require 'rspec'
require 'rainbow'
require_relative '../lib/grid'

RSpec.describe Grid do
  subject(:grid) { described_class.new }

  describe 'cells' do
    it 'has 50 rows' do
      expect(grid.cells.count).to equal 50
    end

    it 'has 50 columns' do
      expect(grid.cells.all? { |row| row.count == 50 }).to be true
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
