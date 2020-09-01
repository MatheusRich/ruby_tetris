# frozen_string_literal: true

require_relative './test_helper'

class TestTetris < Minitest::Test
  def test_that_it_builds_assets
    blocks = build_assets

    exp = [
      '..X.' \
      '..X.' \
      '..X.' \
      '..X.',

      '..X.' \
      '.XX.' \
      '.X..' \
      '....',

      '.X..' \
      '.XX.' \
      '..X.' \
      '....',

      '....' \
      '.XX.' \
      '.XX.' \
      '....',

      '..X.' \
      '.XX.' \
      '..X.' \
      '....',

      '....' \
      '.XX.' \
      '..X.' \
      '..X.',

      '....' \
      '.XX.' \
      '.X..' \
      '.X..'
    ]

    blocks.zip(exp).each do |block, expected_block|
      assert_equal expected_block, block
    end
  end
end
