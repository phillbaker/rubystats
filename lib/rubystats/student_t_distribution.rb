require 'rubystats/probability_distribution'
require 'rubystats/normal_distribution'
# This class provides an object for encapsulating student t distributions
module Rubystats
  class StudentTDistribution < Rubystats::ProbabilityDistribution
    include Rubystats::SpecialMath

    # Constructs a student t distribution.
    def initialize(degree_of_freedom=1.0)
      raise "Argument Error: degrees of freedom for student t distribution must be greater than zero." if degree_of_freedom <= 0.0
      @dof = degree_of_freedom.to_f   
      @pdf_factor = Math.gamma((@dof + 1.0) / 2.0) / ( Math.sqrt(@dof * Math::PI) * Math.gamma(@dof / 2.0))	  
	  @stdnorm = Rubystats::NormalDistribution.new(0.0,1.0)	  
    end

    # Returns the mean of the distribution
    def get_mean
      (@dof > 1) ? 0.0 : Float::NAN      
    end

    # Returns the standard deviation of the distribution
    def get_standard_deviation
      return Math.sqrt(get_variance)
    end

    # Returns the variance of the distribution
    def get_variance
      (@dof > 2.0) ? (@dof / (@dof - 2)) : Float::NAN      
    end

    private

    # Obtain single PDF value
    # Returns the probability that a stochastic variable x has the value X,
    # i.e. P(x=X)
    def get_pdf(x)      
      return @pdf_factor * (1.0 + (x**2.0) / @dof)**(-(@dof+1.0)/2.0)
    end

    # Obtain single CDF value
    # Returns the probability that a stochastic variable x is less than X,
    # i.e. P(x<X)
    def get_cdf(x)
      raise "method 'cdf' not implemented for student t"
    end

    # Obtain single inverse CDF value.
    #	returns the value X for which P(x&lt;X).
    def get_icdf(p)
      raise "method 'icdf' not implemented for student t"
    end

    # returns single random number from the student t distribution
    def get_rng
	  k = @dof.to_i
	  samples = []
	  k.times {|i| samples << @stdnorm.rng }
	  factor = 1.0 / Math.sqrt(samples.inject(0.0) {|sum,x| sum + x**2} / k)
      return (factor * @stdnorm.rng)
    end
  end
end
