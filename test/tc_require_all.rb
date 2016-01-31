$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

#
# test that we can use old api that wasn't namespaced
#

require 'minitest/autorun'
require 'rubystats'

class TestNormal < MiniTest::Unit::TestCase
  def test_simple
    norm = NormalDistribution.new(10,2)
    cdf = norm.cdf(11)

    assert_equal("0.6914624612740131",cdf.to_s)
    refute_nil(norm.rng)

    expd = ExponentialDistribution.new(2)
  end
end
