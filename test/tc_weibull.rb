$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'minitest/autorun'
require 'rubystats/weibull_distribution'

class TestWeibull < MiniTest::Unit::TestCase
  def test_simple
    scale = 6.0
    shape = 4.0
    wbd = Rubystats::WeibullDistribution.new(scale,shape)
    assert_in_delta(5.438415, wbd.mean, 0.000001)
    assert_in_delta(2.327813, wbd.variance, 0.000001)
    assert_in_delta(0.0243884, wbd.pdf(2.0), 0.000001)
    assert_in_delta(0.2381909, wbd.pdf(5.0), 0.000001)
    assert_in_delta(0.3826092, wbd.cdf(5.0), 0.000001)
    # make sure the mean of RNG values is close to the expected mean
    rngs = []
    n = 10000
    n.times {|i| rngs << wbd.rng }
    avg = rngs.inject(0.0) {|sum,x|sum + x} / rngs.size
    assert_in_delta(avg, 5.438415, 0.1)

    x_vals = [0.5, 1, 1.5, 2, 2.5, 3, 3.5]
    
    p_vals = wbd.pdf(x_vals)
    c_vals = wbd.cdf(x_vals)
    
    expected_pvals = [0.00038578, 0.00308404, 0.01037606, 0.02438840, 0.04679345, 0.07828442, 0.11786168]
    expected_cvals = [0.00004822, 0.00077131, 0.00389863, 0.01226978, 0.02969111, 0.06058694, 0.10933684]

    x_vals.size.times do |i|
      assert_in_delta expected_pvals[i], p_vals[i], 0.000001
      assert_in_delta expected_cvals[i], c_vals[i], 0.000001
    end
    
    x_vals.each do |x|
      cdf = wbd.cdf(x)
      inv_cdf = wbd.icdf(cdf)
      assert_in_delta(x, inv_cdf, 0.00000001)
    end
  end
  
  def test_integer_input
    scalei,shapei = 6, 4
    scalef,shapef = 6.0, 4.0
    xi = 3
    xf = 3.0
    dwbi = Rubystats::WeibullDistribution.new(scalei,shapei).pdf(xi)
    dwbf = Rubystats::WeibullDistribution.new(scalef,shapef).pdf(xf)
    assert_in_delta dwbi, dwbf, 0.000001   
  end
end
