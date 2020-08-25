# frozen_string_literal: true

class Field
  HEIGHT = 12
  WIDTH = 18

  module Tile
    BLANK = 0
    BORDER = 9
  end

  def initialize
    @tiles = build_tiles
  end

  def at(x, y)
    @tiles[coordinates(x, y)]
  end

  def empty_at?(x, y)
    at(x, y) == Tile::BLANK
  end

  def filled_at?(x, y)
    at(x, y) != Tile::BLANK
  end

  def inside_x?(x)
    x >= 0 && x < Field::WIDTH
  end

  def inside_y?(y)
    y >= 0 && y < Field::HEIGHT
  end

  def each_coord
    (0...WIDTH).each do |x|
      (0...HEIGHT).each do |y|
        yield(x, y)
      end
    end
  end

  private

  attr_reader :tiles

  def coordinates(x, y)
    (y * WIDTH) + x
  end

  def build_tiles
    field = []

    each_coord do |x, y|
      field[coordinates(x, y)] = tile_for(x, y)
    end

    field
  end

  def tile_for(x, y)
    x.zero? || x == WIDTH - 1 || y == HEIGHT - 1 ? Tile::BORDER : Tile::BLANK
  end
end
