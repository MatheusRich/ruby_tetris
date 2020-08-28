# frozen_string_literal: true

require 'io/console'
require 'json'
require_relative 'fake_io'
require_relative 'field'

DRAW_OFFSET = 2
SCREEN_WIDTH = Field::WIDTH + DRAW_OFFSET * 2
SCREEN_HEIGHT = Field::HEIGHT + DRAW_OFFSET * 2

class Canvas
  attr_reader :canvas

  def initialize
    @canvas = init_canvas
  end

  def [](x, y)
    @canvas[at(x, y)]
  end

  def []=(x, y, value)
    @canvas[at(x, y)] = value
  end

  def render(score, high_scores)
    @io.write(@screen)
    puts "Score: #{score}"
    puts "Record: #{high_scores.first['score']} by #{high_scores.first['name']}\n\n"
  end

  private

  def at(x, y)
    (y + DRAW_OFFSET) * SCREEN_WIDTH + (x + DRAW_OFFSET)
  end

  def init_canvas
    # refactor with .map
    screen = []
    (0...SCREEN_WIDTH).each do |x|
      (0...SCREEN_HEIGHT).each do |y|
        screen[y * SCREEN_WIDTH + x] = ' '
      end
    end

    screen
  end
end
