$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'minitest/autorun'
require 'rubystats/cauchy_distribution'

class TestCauchy < MiniTest::Unit::TestCase
  def test_simple
    location = 0.0
    scale = 0.5
    cd = Rubystats::CauchyDistribution.new(location,scale)
    assert_in_delta(0.6366198, cd.pdf(0.0), 0.000001)
    assert_in_delta(0.5, cd.cdf(0.0), 0.00000001)
    assert_in_delta(3.169765, cd.icdf(0.9502), 0.000001)
   
   # make sure the mean of RNG values is close to the expected mean
    rngs = []
    n = 10000
    n.times {|i| rngs << cd.rng }
    quantile = rngs.sort[(0.75*rngs.size).ceil] 
    assert_in_delta(quantile, 0.5, 0.1)

    x_vals = [-2.0, -1.0, -0.5, 0.0, 0.5, 1.0, 2.0]
    
    x_vals.each do |x|
      cdf = cd.cdf(x)
      inv_cdf = cd.icdf(cdf)
      assert_in_delta(x, inv_cdf, 0.00000001)
    end
  end
  
  def test_integer_input
    locationi, scalei = 3, 1
    locationf, scalef = 3.0, 1.0
    xi = 4
    xf = 4.0
    dcdi = Rubystats::CauchyDistribution.new(locationi,scalei).pdf(xi)
    dcdf = Rubystats::CauchyDistribution.new(locationf,scalef).pdf(xf)
    assert_in_delta dcdi, dcdf, 0.00000001   
  end
end
