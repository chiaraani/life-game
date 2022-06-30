# frozen_string_literal: true

require_relative '../lib/setup'
require_relative '../lib/grid'

describe Setup do
  describe 'ask_for_config' do
    subject(:ask_for_config) { described_class.ask_for_config }

    let(:grid) { instance_double(Grid) }
    let(:config) { Grid.config[:default] }
    let(:questions) do
      [
        "How many rows? (#{config[:rows]})",
        "How many columns? (#{config[:columns]})",
        "How long is each phase (in seconds)? (#{config[:phase_duration]})",
        "How many phases? (#{config[:phases]})"
      ].join
    end

    before do
      allow(described_class).to receive(:gets).and_return('5', '3', '0.01', '2')
      allow(grid).to receive(:play)
      allow(Grid).to receive(:new)
        .with({ rows: 5, columns: 3, phase_duration: 0.01, phases: 2 })
        .and_return(grid)
    end

    it 'sets config according to stdin' do
      ask_for_config
      expect(Grid).to have_received(:new)
        .with({ rows: 5, columns: 3, phase_duration: 0.01, phases: 2 })
    end

    it 'calls grid.play' do
      ask_for_config
      expect(grid).to have_received(:play)
    end

    it 'puts questions with default value' do
      expect { ask_for_config }.to output(questions).to_stdout
    end
  end
end
