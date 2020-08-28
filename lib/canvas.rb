# frozen_string_literal: true

require 'io/console'
require 'json'
require_relative 'fake_io'
require_relative 'field'

class Canvas
  DRAW_OFFSET = 2

  attr_reader :canvas

  def initialize(width, height)
    @width = width + DRAW_OFFSET * 2
    @height = height + DRAW_OFFSET * 2
    @canvas = init_canvas
  end

  def dimentions
    [@width, @height]
  end

  def []=(x, y, value)
    @canvas[at(x, y)] = value
  end

  private

  def at(x, y)
    (y + DRAW_OFFSET) * @width + (x + DRAW_OFFSET)
  end

  def init_canvas
    (0...(@width * @height)).map { ' ' }
  end
end
