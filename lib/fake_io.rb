# frozen_string_literal: true

require 'timeout'

class FakeIO
  def initialize(width, height)
    @width = width
    @height = height
  end

  def write(buffer)
    system 'clear'

    (0..@height * @width).each do |i|
      print "\n" if (i % @width).zero? && i != 0

      print buffer[i]
    end
  end

  def input
    system('stty raw -echo')
    Timeout.timeout(0.01) do
      read_char
    end
  rescue Timeout::Error
    nil
  ensure
    system('stty -raw echo')
  end

  private

  KEYS = {
    'A' => :up,
    'B' => :down,
    'C' => :right,
    'D' => :left
  }.freeze

  # def read_char_async
  #   case $stdin.read_nonblock(1).ord
  #   when ' '  then :space
  #   when "\e" # ANSI escape sequence
  #     case $stdin.read_nonblock(1).ord
  #     when '['
  #       KEYS[$stdin.read_nonblock(1).ord]
  #     end
  #   end
  # end

  def read_char
    case $stdin.getch
    when ' '  then :space
    when "\e" # ANSI escape sequence
      case $stdin.getch
      when '['
        a = $stdin.getch

        KEYS[a]
      end
    end
  end
end
