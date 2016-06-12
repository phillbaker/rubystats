$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'minitest/autorun'
require 'rubystats/normal_distribution'

class TestNormal < MiniTest::Unit::TestCase
  def test_cdf

    norm = Rubystats::NormalDistribution.new(10,2)
    cdf = norm.cdf(11)

    assert_equal('0.691462461274013', '%.15f' % cdf)
    refute_nil(norm.rng)
  end
end
