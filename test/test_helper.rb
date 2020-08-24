# frozen_string_literal: true

require 'simplecov'
require 'minitest/autorun'
require 'minitest/reporters'

SimpleCov.start do
  add_filter 'test/**/*.rb'
end

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

require_relative '../lib/tetris'
