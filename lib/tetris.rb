# frozen_string_literal: true

require 'io/console'
require_relative './fake_io'
require_relative './field'

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

# PIECE STUFF

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

TETROMINO_WIDTH = 4
TETROMINO_HEIGHT = 4

def iterate_tetromino
  (0...TETROMINO_WIDTH).each do |x|
    (0...TETROMINO_HEIGHT).each do |y|
      yield(x, y)
    end
  end
end

def piece_fits?(tetromino, rotation, pos_x, pos_y)
  does_it_fit = true
  asdf = ''

  iterate_tetromino do |x, y|
    tile_index = rotate(x, y, rotation)

    tile_x = (pos_x + x)
    tile_y = (pos_y + y)

    next unless $field.inside_x?(tile_x) && $field.inside_y?(tile_y)
    next if $tetrominos[tetromino][tile_index] == '.' || $field.empty_at?(tile_x, tile_y)

    does_it_fit = false
    break
  end

  does_it_fit
end

LETTER_A_IN_ASCII = 65
def piece_tile_for(piece_index)
  (piece_index + LETTER_A_IN_ASCII).chr
end

# SCREEN

def screen_at(x, y)
  (y + DRAW_OFFSET) * SCREEN_WIDTH + (x + DRAW_OFFSET)
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

LEFT = 27
RIGHT = 91

until game_over
  # ======================= Game timing =======================
  sleep 0.1

  # ======================= Input =============================
  key = io.input

  #======================= Game logic ========================
  if key == :left && piece_fits?(current_piece, current_rotation, current_x - 1, current_y)
    current_x -= 1
  end

  if key == :right && piece_fits?(current_piece, current_rotation, current_x + 1, current_y)
    current_x += 1
  end

  if key == :down && piece_fits?(current_piece, current_rotation, current_x, current_y + 1)
    current_y += 1
  end

  break if key == :quit

  if key == :space && piece_fits?(current_piece, current_rotation + 1, current_x, current_y)
    current_rotation += 1
  end

  # ======================= Render output =======================

  # Draw field
  $field.each_coord do |x, y|
    tile = (y + DRAW_OFFSET) * SCREEN_WIDTH + (x + DRAW_OFFSET)
    screen[tile] = ' ABCDEFG=#'[$field.at(x, y)]
  end

  # Draw current piece
  iterate_tetromino do |x, y|
    is_empty_tile = $tetrominos[current_piece][rotate(x, y, current_rotation)] != 'X'

    next if is_empty_tile

    tile_x = current_x + x
    tile_y = current_y + y

    screen[screen_at(tile_x, tile_y)] = piece_tile_for(current_piece)
  end

  # Display frame
  io.write(screen)
  # sleep 10
end
