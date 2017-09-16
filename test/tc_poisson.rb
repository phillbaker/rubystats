$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'minitest/autorun'
require 'rubystats/poisson_distribution'

class TestPoisson < MiniTest::Unit::TestCase
  def test_simple
    rate = 3.5
    k = 6
    
    pois = Rubystats::PoissonDistribution.new(rate)
    cdf = pois.cdf(k)
    pmf = pois.pmf(k)
    pdf = pois.pdf(k)
    mean = pois.mean
    inv_cdf = pois.icdf(cdf)

    assert_equal pmf, pdf
    assert_in_delta(0.0770984, pdf, 0.0000001 )
    assert_in_delta(0.9347119, cdf, 0.0000001)
    assert_equal(k,inv_cdf)
    assert_equal(3.5,mean)
  end
  
  def test_rng
    rate = 3.5
    pois = Rubystats::PoissonDistribution.new(rate)
  
    rngs = []
    n = 1000
    n.times { rngs << pois.rng.to_f }
    avg = rngs.reduce(:+) / rngs.size    
    
    assert_in_delta(avg, pois.mean, 0.5)
  end
end
