# frozen_string_literal: true

require 'timeout'

class FakeIO
  def initialize(width, height)
    @width = width
    @height = height
  end

  def write(buffer)
    i = 0
    output = ''
    while i < @height * @width
      output += "#{buffer[i...(i + @width)].join}\n"

      i += @width
    end
    puts clear_screen + output
  end

  def read
    system('stty raw -echo')
    Timeout.timeout(0.02) do
      read_char
    end
  rescue Timeout::Error
    nil
  ensure
    print "\r\e[J"
    system('stty -raw echo')
  end

  private

  def clear_screen
    @clear_screen ||= "\r#{"\e[A\e[K" * 3}" * @height
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
    when "\e" # ANSI escape sequence
      case $stdin.getch
      when '['
        a = $stdin.getch

        KEYS[a]
      end
    end
  end
end
