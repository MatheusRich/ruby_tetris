# frozen_string_literal: true

require 'minitest/autorun'

Dir.glob('./test/*_test.rb').sort.each { |f| require(f) }
