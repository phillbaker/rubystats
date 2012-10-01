$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'rubystats/exponential_distribution'

class TestExponential < Test::Unit::TestCase
  def test_simple
    lmbda = 1
    expd = Rubystats::ExponentialDistribution.new(lmbda)
    assert_equal(1, expd.mean)
    assert_equal(1, expd.variance)
    assert_in_delta(0.13533528323661, expd.pdf(2), 0.00000001)
    assert_in_delta(0.95021293163214, expd.cdf(3), 0.00000001)
    assert_in_delta(2.9997402949515, expd.icdf(0.9502), 0.00000001)
    assert !expd.rng.nil?
    # make sure the mean of RNG values is close to the expected mean
    rngs = []
    rngsum = 0
    n = 5000
    n.times do 
      rng = expd.rng
      rngs << rng
      rngsum += rng
    end
    avg = rngsum / n
    assert_in_delta(avg, 1, 0.1)

    x_vals = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5]
    p_vals = expd.pdf(x_vals)

    c_vals = expd.cdf(x_vals)
    expected_pvals = [1.0,
    0.60653065971263,
    0.36787944117144,
    0.22313016014843,
    0.13533528323661,
    0.082084998623899,
    0.049787068367864,
    0.030197383422319 ]
    expected_cvals = [0.0,
    0.39346934028737,
    0.63212055882856,
    0.77686983985157,
    0.86466471676339,
    0.9179150013761,
    0.95021293163214,
    0.96980261657768 ]

    0.upto(x_vals.size - 1) do |i|
      assert_in_delta expected_pvals[i], p_vals[i], 0.00000001
      assert_in_delta expected_cvals[i], c_vals[i], 0.00000001
      i += 1
    end

    x_vals.each do |x|
      cdf = expd.cdf(x)
      inv_cdf = expd.icdf(cdf)
      assert_in_delta(x, inv_cdf, 0.00000001)
    end
  end
end
