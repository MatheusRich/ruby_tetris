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
