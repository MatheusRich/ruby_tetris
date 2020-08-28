# frozen_string_literal: true

class Piece
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

  def initialize(x:, y:)
    @sprite = TETROMINOS.sample
    @rotation = DEG_0
    @x = x
    @y = y
  end

  def fits?(field)
    does_it_fit = true

    iterate_tetromino do |x, y|
      tile_pos = tile_position(x, y)
      tile_x = (pos_x + x)
      tile_y = (pos_y + y)

      next if !field.inside_x?(tile_x) || !field.inside_y?(tile_y)
      next if empty_tile?(tile_pos) || field.empty_at?(tile_x, tile_y)

      does_it_fit = false
      break
    end

    does_it_fit
  end

  def iterate_tetromino
    (0...TETROMINO_WIDTH).each do |x|
      (0...TETROMINO_HEIGHT).each do |y|
        yield(x, y)
      end
    end
  end

  def tile_position(x, y)
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

  def move_right!
    @x += 1
  end

  def move_down!
    @y += 1
  end

  def rotate!
    @rotation += 1
  end
end
