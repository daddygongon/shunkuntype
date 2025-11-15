require "minitest/autorun"
require_relative "test_helper"

class SampleTest < Minitest::Test
  def test_truth
    assert_equal true, true
  end
end
