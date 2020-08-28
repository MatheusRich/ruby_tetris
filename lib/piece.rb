# frozen_string_literal: true

require_relative 'string_colors'

class Piece
  using StringColors

  DEG_0 = 0
  DEG_90 = 1
  DEG_180 = 2
  DEG_270 = 3

  TETROMINO_WIDTH = 4
  TETROMINO_HEIGHT = 4
  TETROMINOS = [
    '..X...X...X...X.',
    '..X..XX..X......',
    '.X...XX...X.....',
    '.....XX..XX.....',
    '..X..XX...X.....',
    '.....XX...X...X.',
    '.....XX..X...X..'
  ].freeze

  TILES = [
    '█'.blue,
    '█'.red,
    '█'.green,
    '█'.magenta,
    '█'.brown,
    '█'.cyan,
    '█'.gray
  ].freeze

  attr_accessor :id, :y

  def initialize(x:, y:)
    @id = rand(0...TETROMINOS.size)
    @sprite = TETROMINOS[@id]
    @rotation = DEG_0
    @x = x
    @y = y
  end

  def tile
    @tile ||= TILES[@id]
  end

  def fits?(field)
    does_it_fit = true

    each_tile do |x, y|
      next unless field.inside_x?(x) && field.inside_y?(y)
      next if field.empty_at?(x, y)

      does_it_fit = false
    end

    does_it_fit
  end

  def each_tile
    iterate_tetromino do |tile_i, tile_j|
      sprite = rotate_tile(tile_i, tile_j)
      next if empty_tile?(sprite)

      yield(tile_i + @x, tile_j + @y)
    end
  end

  def iterate_tetromino
    (0...TETROMINO_WIDTH).each do |x|
      (0...TETROMINO_HEIGHT).each do |y|
        yield(x, y)
      end
    end
  end

  def rotate_tile(x, y)
    case @rotation % 4
    when DEG_0
      (y * 4) + x
    when DEG_90
      12 + y - (x * 4)
    when DEG_180
      15 - (y * 4) - x
    when DEG_270
      3 - y + (x * 4)
    else
      raise 'Unexpected rotation degree'
    end
  end

  def empty_tile?(tile_pos)
    @sprite[tile_pos] == '.'
  end

  def solid_tile?(tile_pos)
    !empty_tile?(tile_pos)
  end

  # Movement
  def move_left!
    @x -= 1
  end

  def move_left
    copy = dup
    copy.move_left!

    copy
  end

  def move_right!
    @x += 1
  end

  def move_right
    copy = dup
    copy.move_right!

    copy
  end

  def move_down!
    @y += 1
  end

  def move_down
    copy = dup
    copy.move_down!

    copy
  end

  def rotate!
    @rotation += 1
  end

  def rotate
    copy = dup
    copy.rotate!

    copy
  end
end
