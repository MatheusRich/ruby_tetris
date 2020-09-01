# frozen_string_literal: true

require_relative './test_helper'

class TestBasicMath < Minitest::Test
  def test_that_it_has_degrees
    assert_equal 0, BasicMath::DEG_0
    assert_equal 1, BasicMath::DEG_90
    assert_equal 2, BasicMath::DEG_180
    assert_equal 3, BasicMath::DEG_270
  end

  def test_that_it_rotates_0_degrees
    assert_equal(0, BasicMath.rotate(0, 0, BasicMath::DEG_0))
    assert_equal(4, BasicMath.rotate(0, 1, BasicMath::DEG_0))
    assert_equal(1, BasicMath.rotate(1, 0, BasicMath::DEG_0))
    assert_equal(5, BasicMath.rotate(1, 1, BasicMath::DEG_0))
  end

  def test_that_it_rotates_90_degrees
    assert_equal(12, BasicMath.rotate(0, 0, BasicMath::DEG_90))
    assert_equal(13, BasicMath.rotate(0, 1, BasicMath::DEG_90))
    assert_equal(8, BasicMath.rotate(1, 0, BasicMath::DEG_90))
    assert_equal(9, BasicMath.rotate(1, 1, BasicMath::DEG_90))
  end

  def test_that_it_rotates_180_degrees
    assert_equal(15, BasicMath.rotate(0, 0, BasicMath::DEG_180))
    assert_equal(11, BasicMath.rotate(0, 1, BasicMath::DEG_180))
    assert_equal(14, BasicMath.rotate(1, 0, BasicMath::DEG_180))
    assert_equal(10, BasicMath.rotate(1, 1, BasicMath::DEG_180))
  end

  def test_that_it_rotates_270_degrees
    assert_equal(3, BasicMath.rotate(0, 0, BasicMath::DEG_270))
    assert_equal(2, BasicMath.rotate(0, 1, BasicMath::DEG_270))
    assert_equal(7, BasicMath.rotate(1, 0, BasicMath::DEG_270))
    assert_equal(6, BasicMath.rotate(1, 1, BasicMath::DEG_270))
  end
end
