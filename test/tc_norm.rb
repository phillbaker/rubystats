$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'rubystats/normal_distribution'

class TestNormal < Test::Unit::TestCase
  def test_simple

    norm = Rubystats::NormalDistribution.new(10,2)
    cdf = norm.cdf(11)

    assert_equal("0.691462461274013",cdf.to_s)
    assert_not_nil(norm.rng)
  end
end
