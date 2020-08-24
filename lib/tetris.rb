# frozen_string_literal: true

def build_assets
  tetromino = Array.new(7, '')

  tetromino[0] += '..X...X...X...X.'
  tetromino[1] += '..X..XX..X......'
  tetromino[2] += '.X...XX...X.....'
  tetromino[3] += '.....XX..XX.....'
  tetromino[4] += '..X..XX...X.....'
  tetromino[5] += '.....XX...X...X.'
  tetromino[6] += '.....XX..X...X..'

  tetromino
end

DEG_0 = 0
DEG_90 = 1
DEG_180 = 2
DEG_270 = 3

def rotate(x, y, degree)
  case degree % 4
  when DEG_0
    (y * 4) - x
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

module Field
  HEIGHT = 12
  WIDTH = 318

  BLANK = 0
  BORDER = 9

  extend self

  def coordinates(x, y)
    y * WIDTH + x
  end

  def build
    field = []

    (0..WIDTH).each do |x|
      (0..HEIGHT).each do |y|
        field[coordinates(x, y)] = tile_for(x, y)
      end
    end

    field
  end

  def tile_for(x, y)
    x.zero? || x == WIDTH - 1 || y == HEIGHT - 1 ? BORDER : BLANK
  end
end

tetrominos = build_assets
field = Field.build
pp field
