# frozen_string_literal: true

require 'simplecov'
require 'minitest/reporters'

SimpleCov.start do
  add_filter '/test/'
end

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

require_relative '../lib/tetris'
require_relative '../lib/basic_math'
