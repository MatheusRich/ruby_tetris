# frozen_string_literal: true

module BasicMath
  DEG_0 = 0
  DEG_90 = 1
  DEG_180 = 2
  DEG_270 = 3

  module_function

  def rotate(x, y, rotation)
    case rotation % 4
    when DEG_0
      (y * 4) + x
    when DEG_90
      12 + y - (x * 4)
    when DEG_180
      15 - (y * 4) - x
    when DEG_270
      3 - y + (x * 4)
    else
      raise 'Unexpected rotation degree'
    end
  end
end
