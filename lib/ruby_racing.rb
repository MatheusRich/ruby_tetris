# frozen_string_literal: true

# require_relative 'canvas'
# require_relative 'fake_io'
# require_relative 'field'
# require 'rich_engine'
require_relative 'car'

FPS = 30
INITIAL_SPEED = 30

class RubyRacing
  def self.play
    new.play
  end

  def initialize
    # @canvas = Canvas.new(Field::WIDTH, Field::HEIGHT)
    # @io = FakeIO.new(*@canvas.dimentions)
    # @field = Field.new
    # @piece = new_piece
    # @score = 0
    # @record = JSON.parse(File.read('./record.json'))
  end

  def play
    puts Car.new(x:0, y:0)

    # game_over = false
    # game_speed = INITIAL_SPEED
    # speed_counter = 0
    # delivered_pieces = 0

    # until game_over
    #   # ======================= Game timing =======================
    #   t1 = Time.now
    #   speed_counter += 1
    #   should_force_piece_down = (speed_counter == game_speed)

    #   # ======================= Input =============================
    #   key = @io.read

    #   #======================= Game logic ========================
    #   break if key == :quit

    #   handle_input(key)

    #   if should_force_piece_down
    #     if @piece.try(:move_down).fits?(@field)
    #       @piece.move_down!
    #     else
    #       delivered_pieces += 1
    #       game_speed -= 1 if (delivered_pieces % 10 == 0) && game_speed.positive?

    #       @field.lock_piece!(piece)
    #       @field.check_for_lines!(@piece.y)

    #       @score += 25
    #       @score += ((1 << @field.lines.size) * 100) if @field.lines.any?

    #       @piece = new_piece
    #       game_over = !@piece.fits?(@field)
    #     end

    #     speed_counter = 0
    #   end

    #   # ======================= Render output =======================

    #   draw_field!
    #   draw_piece!
    #   draw_lines!

    #   t2 = Time.now
    #   elapsed_time = t2 - t1
    #   sleep_time = (1.0 / FPS) - elapsed_time
    #   render_canvas sleep_time


    #   sleep sleep_time if sleep_time.positive?
    # end

    # on_game_over
  end

  private

  attr_accessor :piece, :screen, :score, :record

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
    @canvas.draw_field!(@field)
  end

  def draw_piece!
    @canvas.draw_piece!(@piece)
  end

  def draw_lines!
    return if @field.lines.empty?

    render_canvas # HACK: Showing lines
    sleep 0.3

    @field.drop_lines!
  end

  def render_canvas sleep_time
    @io.write(@canvas.canvas)
    puts "#{1/sleep_time} FPS"
    sleep 0.1
    puts "Score: #{score}"
    puts "Record: #{record['score']} by #{record['name']}\n\n"
  end

  def on_game_over
    puts 'Game over!'

    update_record if score > record['score']
  end

  def update_record
    system 'clear'
    puts 'New record! What is your name?'
    print '> '
    name = gets.chomp

    record = { 'name' => name, 'score' => score }

    File.write('record.json', record.to_json)
  end
end
