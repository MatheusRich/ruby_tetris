# frozen_string_literal: true

require_relative 'canvas'
require_relative 'field'
require_relative 'piece'

FPS = 30
INITIAL_SPEED = 30

DRAW_OFFSET = 2
SCREEN_WIDTH = Field::WIDTH + DRAW_OFFSET * 2
SCREEN_HEIGHT = Field::HEIGHT + DRAW_OFFSET * 2

TILES = [
  ' ', # Nothing
  *Piece::TILES,
  '=', # Line
  '░'  # Wall
].freeze

class Tetris
  def self.play
    new.play
  end

  def initialize
    @io = FakeIO.new(SCREEN_WIDTH, SCREEN_HEIGHT)
    @field = Field.new
    @piece = new_piece
    @canvas = Canvas.new
    @score = 0
    @high_scores = JSON.parse(File.read('./high_scores.json'))
  end

  def play
    game_over = false
    game_speed = INITIAL_SPEED
    speed_counter = 0
    delivered_pieces = 0

    until game_over
      # ======================= Game timing =======================
      t1 = Time.now
      speed_counter += 1
      should_force_piece_down = (speed_counter == game_speed)

      # ======================= Input =============================
      key = @io.read

      #======================= Game logic ========================
      break if key == :quit

      handle_input(key)

      if should_force_piece_down
        if @piece.try(:move_down).fits?(@field)
          @piece.move_down!
        else
          @field.lock_piece!(piece)

          delivered_pieces += 1
          game_speed -= 1 if (delivered_pieces % 10 == 0) && game_speed.positive?

          @field.check_for_lines!(@piece.y)

          @score += 25
          @score += ((1 << @field.lines.size) * 100) if @field.lines.any?

          @piece = new_piece
          game_over = !@piece.fits?(@field)
        end

        speed_counter = 0
      end

      # ======================= Render output =======================

      draw_field!
      draw_piece!
      draw_lines!
      render_canvas

      t2 = Time.now
      elapsed_time = t2 - t1
      sleep_time = (1.0 / FPS) - elapsed_time

      sleep sleep_time if sleep_time.positive?
    end

    on_game_over
  end

  private

  attr_accessor :piece, :screen, :score, :high_scores

  def new_piece
    Piece.new(x: Field::WIDTH / 2, y: 0)
  end

  def handle_input(key)
    @piece.move_left! if key == :left && @piece.try(:move_left).fits?(@field)
    @piece.move_right! if key == :right && @piece.try(:move_right).fits?(@field)
    @piece.move_down! if key == :down && @piece.try(:move_down).fits?(@field)
    @piece.rotate! if key == :space && @piece.try(:rotate).fits?(@field)
  end

  def draw_field!
    @field.each_coord do |x, y|
      @canvas[x, y] = TILES[@field.at(x, y)]
    end
  end

  def draw_piece!
    @piece.each_tile do |x, y|
      @canvas[x, y] = @piece.tile
    end
  end

  def draw_lines!
    return if @field.lines.empty?

    render_canvas # HACK: Showing lines
    sleep 0.3

    @field.drop_lines!
  end

  def render_canvas
    @io.write(@canvas.canvas)
    puts "Score: #{score}"
    puts "Record: #{high_scores.first['score']} by #{high_scores.first['name']}\n\n"
  end

  def on_game_over
    puts 'Game over!'
  end
end
