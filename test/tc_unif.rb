$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'minitest/autorun'
require 'rubystats/uniform_distribution'

class TestUnif < MiniTest::Unit::TestCase
  def test_cdf

    unif = Rubystats::UniformDistribution.new(1,6)
    cdf = unif.cdf(2.5)

    assert_equal 0.3, cdf
  end

  def test_pdf
    unif = Rubystats::UniformDistribution.new(1.0, 6.0)
    
    pdf = unif.pdf(2.5)
    assert_equal 0.2, pdf

    pdf_out_of_lower_bounds = unif.pdf(0.0)
    assert_equal 0.0, pdf_out_of_lower_bounds
 
    pdf_out_of_upper_bounds = unif.pdf(8.0)
    assert_equal 0.0, pdf_out_of_upper_bounds
  end
  
  def test_rng
    lower, upper = 1,6
    unif = Rubystats::UniformDistribution.new(lower,upper)
    
    total = 10000
    values = Array.new(total).map{unif.rng}
    
    assert_equal values.min >= lower, true
    assert_equal values.max <= upper, true
  end
  
  def test_integer_input
    loweri, upperi = 1, 6
    lowerf, upperf = 1.0, 6.0
    xi = 3
    xf = 3.0
    dunifi = Rubystats::NormalDistribution.new(loweri,upperi).pdf(xi)
    duniff = Rubystats::NormalDistribution.new(lowerf,upperf).pdf(xf)
    assert_in_delta dunifi, duniff, 0.00000001   
  end
  
end
