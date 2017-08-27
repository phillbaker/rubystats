$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'minitest/autorun'
require 'rubystats/gamma_distribution'

class TestGamma < MiniTest::Unit::TestCase
  def test_simple
    shape = 3.0
    scale = 2.0
    gamma = Rubystats::GammaDistribution.new(shape,scale)
   
    #check properties
    assert_in_delta(6.0, gamma.mean, 0.000001)
    assert_in_delta(12.0, gamma.variance, 0.000001)
    
    #check distributions
    assert_in_delta(0.0, gamma.pdf(0.0), 0.000001)
    assert_in_delta(0.1353353, gamma.pdf(4.0), 0.000001)
    assert_in_delta(0.001134998, gamma.pdf(20.0), 0.000001)
    assert_in_delta(0.5768099, gamma.cdf(6.0), 0.01)
    assert_in_delta(0.986246, gamma.cdf(16.0), 0.01)
    
   # make sure the mean of RNG values is close to the expected mean
    rngs = []
    n = 10000
    n.times {|i| rngs << gamma.rng }
    quantile = rngs.sort[(0.75*rngs.size).ceil] 
    assert_in_delta(quantile, 7.84080, 0.2)
  end
  
  def test_integer_input
    shapei, scalei = 3, 1
    shapef, scalef = 3.0, 1.0
    xi = 4
    xf = 4.0
    pdfi = Rubystats::GammaDistribution.new(shapei,scalei).pdf(xi)
    pdff = Rubystats::GammaDistribution.new(shapef,scalef).pdf(xf)
    assert_in_delta pdfi, pdff, 0.00000001   
  end
end