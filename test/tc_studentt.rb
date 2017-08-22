$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'minitest/autorun'
require 'rubystats/student_t_distribution'

class TestStudentT < MiniTest::Unit::TestCase
  def test_pdf
    t = Rubystats::StudentTDistribution.new(8)
        
    pdf = t.pdf(0.0)
    assert_in_epsilon pdf, 0.386699, 0.000001, "pdf"
  
	pdf = t.pdf(1.0)
    assert_in_epsilon pdf, 0.2276076, 0.000001, "pdf"  
  end

  def test_properties
    t = Rubystats::StudentTDistribution.new(8)
    assert_in_epsilon t.mean, 0.0, 0.01, "mean"
    assert_in_epsilon t.variance, 1.333, 0.01, "variance"
  end
  
  def test_rng
    t = Rubystats::StudentTDistribution.new(8)
    
    total = 100000
    values = Array.new(total).map{t.rng}

    mean = values.inject(0.0) {|sum, v| sum + v} / values.size 
    assert_in_delta mean, 0.0, 0.1, "rng mean"    
	
	var = values.inject(0.0) {|sum, v| sum + (v - mean)**2} / values.size 
    assert_in_delta var, 8.0/(8.0-2.0), 0.1, "rng mean"    
  end
  
  def test_integer_input
    dfi, dff = 8, 8.0
	xi,xf = 1, 1.0
    dti = Rubystats::StudentTDistribution.new(dfi).pdf(xi)
    dtf = Rubystats::StudentTDistribution.new(dff).pdf(xf)
    assert_in_delta dti, dtf, 0.000001   
  end
  
end
