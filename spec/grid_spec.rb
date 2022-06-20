# frozen_string_literal: true

require 'rspec'
require_relative '../lib/grid'

RSpec.describe Grid do
  subject { Grid.new }

  describe 'cells' do
    it 'has 50 rows and 50 columns and each cell is either true or false' do
      expect(subject.cells.count).to equal 50
      subject.cells.each do |row|
        expect(row.count).to equal 50
        expect(row).to all(be(true).or(be(false)))
      end
    end
  end
end
