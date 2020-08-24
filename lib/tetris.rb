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
  case degree
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
