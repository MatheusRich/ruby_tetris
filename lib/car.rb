# frozen_string_literal: true

require_relative 'string_colors'
require_relative 'basic_math'

class Car
  using StringColors

  SPRITE1 = '▀▀█▀▀'.red + "\n" +
            '█'.black + '-█-'.red + '█'.black + "\n" +
            ' ▃█▃ '.red + "\n" +
            ' █'.red + 'o' + '█ '.red + "\n" +
            ' ███ '.red + "\n" +
            '█'.black + '███'.red + '█'.black + "\n" +
            ' === '.red
  SPRITE2 = '▀▀█▀▀'.red + "\n" +
            '▓'.black + '-█-'.red + '▓'.black + "\n" +
            ' ▃█▃ '.red + "\n" +
            ' █'.red + 'o' + '█ '.red + "\n" +
            ' ███ '.red + "\n" +
            '▓'.black + '███'.red + '▓'.black + "\n" +
            ' === '.red

  def initialize(x:, y:)
    @x = x
    @y = y
  end

  def to_s
    loop do
      system 'clear'
      puts SPRITE1
      sleep 0.2
      system 'clear'
      puts SPRITE2
      sleep 0.2
    end
  end

  # def fits?(field)
  #   does_it_fit = true

  #   each_tile do |x, y|
  #     next unless field.inside_x?(x) && field.inside_y?(y)
  #     next if field.empty_at?(x, y)

  #     does_it_fit = false
  #   end

  #   does_it_fit
  # end

  # def each_tile
  #   iterate_tetromino do |tile_i, tile_j|
  #     sprite = BasicMath.rotate(tile_i, tile_j, @rotation)
  #     next if empty_tile?(sprite)

  #     yield(tile_i + @x, tile_j + @y)
  #   end
  # end

  # # Movement
  # def move_left!
  #   @x -= 1
  # end

  # def move_right!
  #   @x += 1
  # end

  # def move_down!
  #   @y += 1
  # end

  # def rotate!
  #   @rotation += 1
  # end

  # def try(movement)
  #   copy = dup
  #   copy.public_send("#{movement}!")

  #   copy
  # end
end
