# frozen_string_literal: true

require 'timeout'
# $stdout.sync = true

class FakeIO
  def initialize(width, height)
    @width = width
    @height = height
  end

  def write(buffer)
    clear_screen

    i = 0
    while i < @height * @width
      print buffer[i...(i + @width)].join

      print "\n"

      i += @width
    end
  end

  def read
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

  def clear_screen
    @height.times { print "\r" + ("\e[A\e[K" * 3) }
  end

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
    when ' ' then :space
    when 'q' then :quit
    when "\e" # ANSI escape sequence
      case $stdin.getch
      when '['
        a = $stdin.getch

        KEYS[a]
      end
    end
  end
end
