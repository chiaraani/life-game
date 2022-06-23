# frozen_string_literal: true

require_relative 'grid'

# Setup asks client for config variables
module Setup
  def self.ask(variable, question)
    print "#{question} (#{Grid.config[:default][variable]})"
    answer = $stdin.gets

    @config[variable] = answer.to_i unless answer.strip.empty?
  end

  def self.ask_for_config
    @config = {}

    ask :rows, 'How many rows?'
    ask :columns, 'How many columns?'
    ask :phase_duration, 'How long is each phase (in seconds)?'
    ask :phases, 'How many phases?'

    Grid.new(**@config).play
  end
end

Setup.ask_for_config
