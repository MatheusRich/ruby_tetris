# frozen_string_literal: true

module StringColors
  refine String do
    def black
      color(30)
    end

    def red
      color(31)
    end

    def green
      color(32)
    end

    def brown
      color(33)
    end

    def blue
      color(34)
    end

    def magenta
      color(35)
    end

    def cyan
      color(36)
    end

    def gray
      color(37)
    end

    def bg_black;       "\e[40m#{self}\e[0m" end
    def bg_red;         "\e[41m#{self}\e[0m" end
    def bg_green;       "\e[42m#{self}\e[0m" end
    def bg_brown;       "\e[43m#{self}\e[0m" end
    def bg_blue;        "\e[44m#{self}\e[0m" end
    def bg_magenta;     "\e[45m#{self}\e[0m" end
    def bg_cyan;        "\e[46m#{self}\e[0m" end
    def bg_gray;        "\e[47m#{self}\e[0m" end

    private

    def color(n)
      "\e[#{n}m#{self}\e[0m"
    end
  end
end
