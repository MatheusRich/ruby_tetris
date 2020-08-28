# frozen_string_literal: true

require 'io/console'
require 'json'
require_relative 'fake_io'
require_relative 'field'
require_relative 'colors'
require_relative 'piece'

INITIAL_SPEED = 30
FPS = 30
SCREEN_WIDTH = 22
SCREEN_HEIGHT = 16
DRAW_OFFSET = 2
TILES = [
  ' ', # Nothing
  *Piece::TILES,
  '=', # Line
  '░'  # Wall
].freeze

# SCREEN

def screen_at(x, y)
  (y + DRAW_OFFSET) * SCREEN_WIDTH + (x + DRAW_OFFSET)
end

########################### MAIN ###########################

class Tetris
  def self.play
    new.play
  end

  def initialize
    @io = FakeIO.new(SCREEN_WIDTH, SCREEN_HEIGHT)
    @field = Field.new
    @tetrominos = Piece::TETROMINOS
  end

  def play
    high_scores = JSON.parse(File.read('./high_scores.json'))
    game_over = false

    piece = new_piece
    speed = INITIAL_SPEED
    speed_counter = 0
    pieces_count = 0

    score = 0

    # Initializing screen canvas
    screen = init_canvas

    until game_over
      # ======================= Game timing =======================
      t0 = Time.now
      speed_counter += 1
      should_force_down = (speed_counter == speed)

      # ======================= Input =============================
      key = @io.read

      #======================= Game logic ========================
      if key == :left && piece.move_left.fits?(@field)
        piece.move_left!
      end

      if key == :right && piece.move_right.fits?(@field)
        piece.move_right!
      end

      if key == :down && piece.move_down.fits?(@field)
        piece.move_down!
      end

      if key == :space && piece.rotate.fits?(@field)
        piece.rotate!
      end

      break if key == :quit

      if should_force_down
        if piece.move_down.fits?(@field)
          piece.move_down!
        else
          @field.lock_piece!(piece)

          pieces_count += 1
          speed -= 1 if (pieces_count % 10 == 0) && speed >= 0

          @field.check_for_lines!(piece.y)

          score += 25
          score += ((1 << @field.lines.size ) * 100) if @field.lines.any?

          # Choose next piece
          piece = new_piece

          game_over = !piece.fits?(@field)
        end

        speed_counter = 0
      end

      # ======================= Render output =======================

      # Draw field
      @field.each_coord do |x, y|
        tile = (y + DRAW_OFFSET) * SCREEN_WIDTH + (x + DRAW_OFFSET)
        screen[tile] = TILES[@field.at(x, y)]
      end

      # Draw current piece
      piece.each_tile do |x, y|
        screen[screen_at(x, y)] = piece.tile
      end

      if @field.lines.any?
        @io.write(screen)
        puts "Score: #{score}"
        puts "Record: #{high_scores.first['score']}\n\n"
        sleep 0.3

        @field.drop_lines!
      end

      render_canvas(screen, score, high_scores)

      tf = Time.now
      elapsed_time = tf - t0
      sleep_time = (1.0 / FPS) - elapsed_time

      sleep sleep_time if sleep_time.positive?
    end

    on_game_over
  end

  private

  def init_canvas
    screen = []
    (0...SCREEN_WIDTH).each do |x|
      (0...SCREEN_HEIGHT).each do |y|
        screen[y * SCREEN_WIDTH + x] = ' '
      end
    end

    screen
  end

  def render_canvas(screen, score, high_scores)
    @io.write(screen)
    puts "Score: #{score}"
    puts "Record: #{high_scores.first['score']} by #{high_scores.first['name']}\n\n"
  end

  def on_game_over
    puts 'Game over!'
  end

  def new_piece
    Piece.new(x: Field::WIDTH / 2, y: 0)
  end
end
