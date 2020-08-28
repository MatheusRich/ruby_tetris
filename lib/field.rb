# frozen_string_literal: true

require_relative 'piece'

class Field
  HEIGHT = 12
  WIDTH  = 18

  module Tile
    BLANK  = 0
    LINE   = 8
    BORDER = 9
  end

  TILES = [
    ' ', # Nothing
    *Piece::TILES,
    '=', # Line
    '░'  # Wall
  ].freeze

  attr_accessor :lines

  def initialize
    @tiles = build_tiles
    @lines = []
  end

  def []=(x, y, value)
    @tiles[at(x, y)] = value
  end

  def [](x, y)
    @tiles[at(x, y)]
  end

  def tile_at(x, y)
    TILES[self[x, y]]
  end

  def empty_at?(x, y)
    self[x, y] == Tile::BLANK
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
      self[x, y] = piece.id + 1
    end
  end

  def check_for_lines!(piece_y)
    (0...4).each do |y|
      pos_y = piece_y + y

      next if pos_y >= Field::HEIGHT - 1

      has_complete_line = not_wall_columns.all? { |x| filled_at?(x, pos_y) }

      next unless has_complete_line

      not_wall_columns.each { |x| self[x, pos_y] = Tile::LINE }

      lines << pos_y
    end
  end

  def drop_lines!
    lines.each do |line_y_pos|
      not_wall_columns.each do |x|
        line_y_pos.downto(1) do |y|
          self[x, y] = self[x, y - 1]
        end

        set_pos(x, as: Field::Tile::BLANK)
      end
    end

    clear_lines!
  end

  private

  attr_reader :tiles

  def at(x, y)
    (y * WIDTH) + x
  end

  def build_tiles
    field = []

    each_coord do |x, y|
      field[at(x, y)] = tile_for(x, y)
    end

    field
  end

  def tile_for(x, y)
    x.zero? || x == WIDTH - 1 || y == HEIGHT - 1 ? Tile::BORDER : Tile::BLANK
  end

  def not_wall_columns
    @not_wall_columns ||= 1...(Field::WIDTH - 1)
  end

  def set_pos(pos, as:)
    @tiles[pos] = as
  end
end
