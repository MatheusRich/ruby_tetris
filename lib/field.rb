# frozen_string_literal: true

class Field
  HEIGHT = 12
  WIDTH = 18
  BLANK = 0
  BORDER = 9

  def initialize
    @tiles = build_tiles
  end

  def at(x, y)
    @tiles[coordinates(x, y)]
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
    y * WIDTH + x
  end

  def build_tiles
    field = []

    (0...WIDTH).each do |x|
      (0...HEIGHT).each do |y|
        field[coordinates(x, y)] = tile_for(x, y)
      end
    end

    field
  end

  def tile_for(x, y)
    x.zero? || x == WIDTH - 1 || y == HEIGHT - 1 ? BORDER : BLANK
  end
end
