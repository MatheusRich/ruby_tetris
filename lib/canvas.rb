# frozen_string_literal: true

require 'io/console'
require 'json'
require_relative 'piece'

class Canvas
  DRAW_OFFSET = 2
  TILES = [
    ' ', # Nothing
    *Piece::TILES,
    '=', # Line
    '░'  # Wall
  ].freeze

  attr_reader :canvas

  def initialize(width, height)
    @width = width + DRAW_OFFSET * 2
    @height = height + DRAW_OFFSET * 2
    @canvas = init_canvas
  end

  def dimentions
    [@width, @height]
  end

  def draw_piece!(piece)
    piece.each_tile do |x, y|
      self[x, y] = TILES[piece.id + 1]
    end
  end

  def draw_field!(field)
    field.each_coord do |x, y|
      self[x, y] = TILES[field[x, y]]
    end
  end

  private

  def []=(x, y, value)
    @canvas[at(x, y)] = value
  end

  def at(x, y)
    (y + DRAW_OFFSET) * @width + (x + DRAW_OFFSET)
  end

  def init_canvas
    (0...(@width * @height)).map { ' ' }
  end
end
