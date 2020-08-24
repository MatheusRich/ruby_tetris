# frozen_string_literal: true

class FakeIO
  def initialize(width, height)
    @width = width
    @height = height
  end

  def write(buffer)
    system 'clear'

    (0..@height * @width).each do |i|
      puts '' if (i % @width).zero? && i != 0

      print buffer[i]
    end
  end
end
