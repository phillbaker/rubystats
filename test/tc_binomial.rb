$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'minitest/autorun'
require 'rubystats/binomial_distribution'

class TestBinomial < MiniTest::Unit::TestCase
  def test_simple
    t = 100
    f = 7
    p = 0.05

    bin = Rubystats::BinomialDistribution.new(t,p)
    cdf = bin.cdf(f)
    pmf = bin.pmf(f)
    pdf = bin.pdf(f)
    mean = bin.mean
    inv_cdf = bin.icdf(cdf)

    assert_equal pmf, pdf
    assert_in_delta(0.10602553736479, pdf, 0.00000000000001 )
    assert_in_delta(0.87203952137960, cdf, 0.00000000000001)
    assert_equal("5.0",mean.to_s)
    assert_equal(f,inv_cdf)
  end
end
