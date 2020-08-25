# frozen_string_literal: true

require_relative './fake_io'
require_relative './field'

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

########################### MAIN ###########################

SCREEN_WIDTH = 30
SCREEN_HEIGHT = 16
DRAW_OFFSET = 2
io = FakeIO.new(SCREEN_WIDTH, SCREEN_HEIGHT)
tetrominos = build_assets
field = Field.new
screen = []

(0...SCREEN_WIDTH).each do |x|
  (0...SCREEN_HEIGHT).each do |y|
    screen[y * SCREEN_WIDTH + x] = '.'
  end
end

game_over = false

until game_over
  field.each_coord do |x, y|
    screen[(y + DRAW_OFFSET) * SCREEN_WIDTH + (x + DRAW_OFFSET)] = ' ABCDEFG=#'[field.at(x, y)]
  end

  io.write(screen)
  break
end
