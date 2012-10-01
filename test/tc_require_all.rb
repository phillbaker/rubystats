$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

#
# test that we can use old api that wasn't namespaced
#

require 'test/unit'
require 'rubystats'

class TestNormal < Test::Unit::TestCase
  def test_simple
    norm = NormalDistribution.new(10,2)
    cdf = norm.cdf(11)

    assert_equal("0.691462461274013",cdf.to_s)
    assert_not_nil(norm.rng)

    expd = ExponentialDistribution.new(2)
  end
end
