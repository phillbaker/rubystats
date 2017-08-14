require 'rubystats/probability_distribution'
require 'rubystats/normal_distribution'
# This class provides an object for encapsulating lognormal distributions
module Rubystats
  class LognormalDistribution < Rubystats::ProbabilityDistribution
    include Rubystats::SpecialMath

    # Constructs a lognormal distribution.
    def initialize(meanlog=0.0, sdlog=1.0)
      raise "Argument Error: standard deviation for log-normal distribution must be positive." if sdlog < 0.0
      @meanlog = meanlog.to_f
      @sdlog = sdlog.to_f      
      @norm = Rubystats::NormalDistribution.new(@meanlog, @sdlog)
    end

    # Returns the mean of the distribution
    def get_mean 
      return Math.exp(@meanlog + @sdlog**2 / 2.0)
    end

    # Returns the standard deviation of the distribution
    def get_standard_deviation
      return Math.sqrt(get_variance)
    end

    # Returns the variance of the distribution
    def get_variance
      return (Math.exp(@sdlog**2) - 1) * Math.exp(2.0 * @meanlog + @sdlog**2)
    end

    private

    # Obtain single PDF value
    # Returns the probability that a stochastic variable x has the value X,
    # i.e. P(x=X)
    def get_pdf(x)
      raise "Argument Error: x must be greater than zero" if x <= 0.0
      return 1.0/x.to_f * @norm.pdf(Math.log(x.to_f))
    end

    # Obtain single CDF value
    # Returns the probability that a stochastic variable x is less than X,
    # i.e. P(x<X)
    def get_cdf(x)
      return 0.5 + 0.5 * Math.erf((Math.log(x.to_f) - @meanlog) /  (NumericalConstants::SQRT2 * @sdlog))
    end

    # Obtain single inverse CDF value.
    #	returns the value X for which P(x&lt;X).
    def get_icdf(p)
      raise "method 'get_icdf' not implemented for log-normal"
    end

    # returns single random number from log normal
    def get_rng
      return Math.exp(@norm.rng)
    end
  end
end
