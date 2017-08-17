$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'minitest/autorun'
require 'rubystats/lognormal_distribution'

class TestLognormal < MiniTest::Unit::TestCase
  def test_cdf_pdf
    lnorm = Rubystats::LognormalDistribution.new(2.0,0.2)
    
    cdf = lnorm.cdf(8.0)
    assert_in_epsilon cdf, 0.654392, 0.0001, "cdf"
  
    pdf = lnorm.pdf(8.0)
    assert_in_epsilon pdf, 0.2304252, 0.000001, "pdf"
  
  end

  def test_properties
    lnorm = Rubystats::LognormalDistribution.new(2.0,0.2)
    assert_in_epsilon lnorm.mean, 7.538325, 0.000001, "mean"
    assert_in_epsilon lnorm.variance, 2.319127, 0.000001, "variance"
  end
  
  def test_rng
    lnorm = Rubystats::LognormalDistribution.new(2.0,0.2)
    
    total = 100000
    values = Array.new(total).map{lnorm.rng}

    mean = values.inject(0.0) {|sum, v| sum + v} / values.size
    
    assert_in_delta mean, 7.538325, 0.1, "rng mean"
    assert_equal values.min >= 0.0, true, "rng min value"
  end
  
  def test_integer_input
    meani, sdi = 2, 1
    meanf, sdf = 2.0, 1.0
    xi = 9
    xf = 9.0
    dlnormi = Rubystats::LognormalDistribution.new(meani,sdi).pdf(xi)
    dlnormf = Rubystats::LognormalDistribution.new(meanf,sdf).pdf(xf)
    assert_in_delta dlnormi, dlnormf, 0.000001   
  end
  
end
