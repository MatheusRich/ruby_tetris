# frozen_string_literal: true

class Field
  HEIGHT = 12
  WIDTH  = 18

  module Tile
    BLANK  = 0
    LINE   = 8
    BORDER = 9
  end

  attr_accessor :lines

  def initialize
    @tiles = build_tiles
    @lines = []
  end

  def set(x, y, as:)
    @tiles[coordinates(x, y)] = as
  end

  def force_set(pos, as:)
    @tiles[pos] = as
  end

  def at(x, y)
    @tiles[coordinates(x, y)]
  end

  def empty_at?(x, y)
    at(x, y) == Tile::BLANK
  end

  def filled_at?(x, y)
    !empty_at?(x, y)
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

  def clear_lines!
    @lines = []
  end

  def lock_piece!(piece)
    piece.each_tile do |x, y|
      set(x, y, as: piece.id + 1)
    end
  end

  def check_for_lines!(piece_y)
    (0...4).each do |y|
      pos_y = piece_y + y

      next if pos_y >= Field::HEIGHT - 1

      columns = (1...(Field::WIDTH - 1))
      has_complete_line = columns.all? { |x| filled_at?(x, pos_y) }

      next unless has_complete_line

      columns.each { |x| set(x, pos_y, as: Tile::LINE) }

      lines << pos_y
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
