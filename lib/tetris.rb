# frozen_string_literal: true

require_relative './fake_io'
require_relative './field'

TETROMINO_WIDTH = 4
TETROMINO_HEIGHT = 4

def build_assets
  tetrominos = Array.new(7, '')

  tetrominos[0] += '..X...X...X...X.'
  tetrominos[1] += '..X..XX..X......'
  tetrominos[2] += '.X...XX...X.....'
  tetrominos[3] += '.....XX..XX.....'
  tetrominos[4] += '..X..XX...X.....'
  tetrominos[5] += '.....XX...X...X.'
  tetrominos[6] += '.....XX..X...X..'

  tetrominos
end

DEG_0 = 0
DEG_90 = 1
DEG_180 = 2
DEG_270 = 3

def rotate(x, y, degree)
  case degree % 4
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

def piece_fit?(tetromino, rotation, pos_x, pos_y)
  (0...TETROMINO_WIDTH).each do |x|
    (0...TETROMINO_HEIGHT).each do |y|
      piece_index = rotate(pos_x, pos_y, rotation)

      tile_x = (pos_x + x)
      tile_y = (pos_y + y)

      next unless tile_x >= 0 && tile_x < Field::WIDTH

      if tile_y >= 0 && tile_y < Field::HEIGHT
        return false if $tetrominos[tetromino][piece_index] == 'X' && $field.empty_at?(tile_x, tile_y)
      end
    end
  end

  true
end

LETTER_A_IN_ASCII = 65
def piece_tile_for(piece_index)
  (piece_index + LETTER_A_IN_ASCII).chr
end

########################### MAIN ###########################

SCREEN_WIDTH = 22
SCREEN_HEIGHT = 16
DRAW_OFFSET = 2
io = FakeIO.new(SCREEN_WIDTH, SCREEN_HEIGHT)
$tetrominos = build_assets
$field = Field.new
screen = []

(0...SCREEN_WIDTH).each do |x|
  (0...SCREEN_HEIGHT).each do |y|
    screen[y * SCREEN_WIDTH + x] = '.'
  end
end

# Game logic stuff

game_over = false
current_piece = 0
current_rotation = DEG_0
current_x = Field::WIDTH / 2
current_y = 0

until game_over
  # Game timing =======================

  # Input =============================

  # Game logic ========================

  # Render output =======================

  # Draw field
  $field.each_coord do |x, y|
    tile = (y + DRAW_OFFSET) * SCREEN_WIDTH + (x + DRAW_OFFSET)
    screen[tile] = ' ABCDEFG=#'[$field.at(x, y)]
  end

  # Draw current piece
  (0...TETROMINO_WIDTH).each do |x|
    (0...TETROMINO_HEIGHT).each do |y|
      if $tetrominos[current_piece][rotate(x, y, current_rotation)] == 'X'
        screen[
          (current_y + y + DRAW_OFFSET) * SCREEN_WIDTH + (current_x + x + DRAW_OFFSET)
        ] = piece_tile_for(current_piece)
      end
    end
  end

  # Display frame
  io.write(screen)

  sleep 2
  current_piece = (current_piece + 1) % 7
end
