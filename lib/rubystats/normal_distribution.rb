require 'rubystats/probability_distribution'
# This class provides an object for encapsulating normal distributions
# Ported to Ruby from PHPMath class by Bryan Donovan
# Author:: Jaco van Kooten 
# Author:: Paul Meagher
# Author:: Bryan Donovan (http://www.bryandonovan.com)
module Rubystats
  class NormalDistribution < Rubystats::ProbabilityDistribution
    include Rubystats::SpecialMath

    # Constructs a normal distribution (defaults to zero mean and
    # unity variance).
    def initialize(mu=0.0, sigma=1.0)
      @mean = mu
      if sigma <= 0.0
        return "error"
      end
      @stdev = sigma
      @variance = sigma**2
      @pdf_denominator = SQRT2PI * Math.sqrt(@variance)
      @cdf_denominator = SQRT2   * Math.sqrt(@variance)
    end

    # Returns the mean of the distribution
    def get_mean 
      return @mean
    end

    # Returns the standard deviation of the distribution
    def get_standard_deviation
      return @stdev
    end

    # Returns the variance of the distribution
    def get_variance
      return @variance
    end

    private

    # Obtain single PDF value
    # Returns the probability that a stochastic variable x has the value X,
    # i.e. P(x=X)
    def get_pdf(x)
      Math.exp( -((x-@mean)**2) / (2 * @variance)) / @pdf_denominator
    end

    # Obtain single CDF value
    # Returns the probability that a stochastic variable x is less than X,
    # i.e. P(x<X)
    def get_cdf(x)
      complementary_error( -(x - @mean) / @cdf_denominator) / 2
    end

    # Obtain single inverse CDF value.
    #	returns the value X for which P(x&lt;X).
    def get_icdf(p)
      check_range(p)
      if p == 0.0
        return -MAX_VALUE
      end
      if p == 1.0
        return MAX_VALUE
      end
      if p == 0.5
        return @mean
      end

      mean_save = @mean
      var_save = @variance
      pdf_D_save = @pdf_denominator
      cdf_D_save = @cdf_denominator
      @mean = 0.0
      @variance = 1.0
      @pdf_denominator = Math.sqrt(TWO_PI)
      @cdf_denominator = SQRT2
      x = find_root(p, 0.0, -100.0, 100.0)
      #scale back
      @mean = mean_save
      @variance = var_save
      @pdf_denominator = pdf_D_save
      @cdf_denominator = cdf_D_save
      return x * Math.sqrt(@variance) + @mean
    end

    # Uses the polar form of the Box-Muller transformation which
    #	is both faster and more robust numerically than basic Box-Muller
    # transform. To speed up repeated RNG computations, two random values
    # are computed after the while loop and the second one is saved and
    # directly used if the method is called again.
    # see http://www.taygeta.com/random/gaussian.html
    # returns single normal deviate
    def get_rng
      if @use_last
        y1 = @last
        @use_last = false
      else
        w = 1
        until w < 1.0 do
          r1 = Kernel.rand
          r2 = Kernel.rand
          x1 = 2.0 * r1 - 1.0
          x2 = 2.0 * r2 - 1.0
          w  = x1 * x1 + x2 * x2
        end
        w = Math.sqrt((-2.0 * Math.log(w)) / w)
        y1 = x1 * w
        @last = x2 * w
        @use_last = true
      end
      return @mean + y1 * Math.sqrt(@variance)
    end
  end
end
