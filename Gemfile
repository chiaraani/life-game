# frozen_string_literal: true

ruby File.read('.ruby-version').strip
source 'https://rubygems.org'

# Colour terminal
gem 'rainbow'

group :test, :development do
  # Testing
  gem 'guard-rspec'
  gem 'rspec'

  # Linting
  gem 'guard-rubocop'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
end
