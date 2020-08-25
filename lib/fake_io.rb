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
      puts buffer[i...(i + @width)].join

      i += @width
    end
  end

  def read
    system('stty raw -echo')
    Timeout.timeout(0.01) do
      read_char
    end
  rescue Timeout::Error
    print "\r\e[J"
    nil
  ensure
    system('stty -raw echo')
  end

  private

  def clear_screen
    @height.times { print "\r#{"\e[A\e[K" * 3}" }
  end

  KEYS = {
    'A' => :up,
    'B' => :down,
    'C' => :right,
    'D' => :left
  }.freeze

  def read_char
    case $stdin.getch
    when ' ' then :space
    when 'q' then :quit
    when 'n' then :n
    when "\e" # ANSI escape sequence
      case $stdin.getch
      when '['
        a = $stdin.getch

        KEYS[a]
      end
    end
  end
end
