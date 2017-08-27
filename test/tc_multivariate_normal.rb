$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'minitest/autorun'
require 'rubystats/multivariate_normal_distribution'

class TestMultivariateNormal < MiniTest::Unit::TestCase
  def test_simple
    mu = [1.3,-2.5]
    sigma = [[1.0,0.3],[0.3,1.0]]    
    
    mvnorm = Rubystats::MultivariateNormalDistribution.new(mu,sigma)
    
    assert_in_delta(0.0001340771, mvnorm.pdf([1.0,1.0]), 0.000001)
    assert_in_delta(0.131732, mvnorm.pdf([1.0,-2.0]), 0.000001)
    
   
   # make sure the mean of RNG values is close to the expected mean
    rngs = []
    n = 5000
    n.times {|i| rngs << mvnorm.rng }
   
    a,b = rngs.transpose
   
    #check means
    mean_a = a.inject(0.0) {|sum,x| sum + x} / a.size
    assert_in_delta(1.3, mean_a, 0.1)
    
    mean_b = b.inject(0.0) {|sum,x| sum + x} / b.size
    assert_in_delta(1.3, mean_a, 0.1)
    
    #check variances
    var_a = a.inject(0.0) {|sum,x| sum + (x - mean_a)**2 } / a.size
    assert_in_delta(1.0, var_a, 0.1)
    
    var_b = b.inject(0.0) {|sum,x| sum + (x - mean_b)**2 } / b.size
    assert_in_delta(1.0, var_b, 0.1)
    
    #check correlation
    covariance = a.zip(b).map{|xa,xb| (xa-mean_a)*(xb-mean_b)}.inject(0.0){|sum,x| sum + x} / a.size
    correlation = covariance / Math.sqrt(var_a * var_b)
    assert_in_delta(0.3, correlation, 0.1)    
    
  end
  
  def test_integer_input
    mui, sigmai = [1,2], [[1,0.3],[0.3,1]]
    muf, sigmaf = [1.0,2.0], [[1.0,0.3],[0.3,1.0]]
    xi = [1,1]
    xf = [1.0,1.0]
    dmvnormi = Rubystats::MultivariateNormalDistribution.new(mui,sigmai).pdf(xi)
    dmvnormf = Rubystats::MultivariateNormalDistribution.new(muf,sigmaf).pdf(xf)
    assert_in_delta dmvnormi, dmvnormf, 0.00000001   
  end
end
