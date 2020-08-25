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

  def test_that_it_has_degrees
    assert_equal 0, DEG_0
    assert_equal 1, DEG_90
    assert_equal 2, DEG_180
    assert_equal 3, DEG_270
  end

  def test_that_it_rotates_0_degrees
    assert_equal(0, rotate(0, 0, DEG_0))
    assert_equal(4, rotate(0, 1, DEG_0))
    assert_equal(1, rotate(1, 0, DEG_0))
    assert_equal(5, rotate(1, 1, DEG_0))
  end

  def test_that_it_rotates_90_degrees
    assert_equal(12, rotate(0, 0, DEG_90))
    assert_equal(13, rotate(0, 1, DEG_90))
    assert_equal(8, rotate(1, 0, DEG_90))
    assert_equal(9, rotate(1, 1, DEG_90))
  end

  def test_that_it_rotates_180_degrees
    assert_equal(15, rotate(0, 0, DEG_180))
    assert_equal(11, rotate(0, 1, DEG_180))
    assert_equal(14, rotate(1, 0, DEG_180))
    assert_equal(10, rotate(1, 1, DEG_180))
  end

  def test_that_it_rotates_270_degrees
    assert_equal(3, rotate(0, 0, DEG_270))
    assert_equal(2, rotate(0, 1, DEG_270))
    assert_equal(7, rotate(1, 0, DEG_270))
    assert_equal(6, rotate(1, 1, DEG_270))
  end
end
