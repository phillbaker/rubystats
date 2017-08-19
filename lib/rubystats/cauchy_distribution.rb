require 'rubystats/probability_distribution'
module Rubystats
  class CauchyDistribution < Rubystats::ProbabilityDistribution
    
    def initialize(location=1.0,scale=1.0) 
      if scale <= 0.0
        raise ArgumentError.new("Scale parameter in Cauchy distribution should be greater than zero.")
      end
      @location = location.to_f
      @scale = scale.to_f
    end

    private

    def get_mean 
      Float::NAN
    end

    def get_variance 
      Float::NAN
    end

    # Private method to obtain single PDF value.
    # x should be greater than 0  
    # returns the probability that a stochastic variable x has the value X, i.e. P(x=X). 
    def get_pdf(x) 
      1.0 / (Math::PI * @scale * (1.0 + ((x - @location) / @scale)**2))
    end

    # Private method to obtain single CDF value.
    # param x should be greater than 0    
    # return the probability that a stochastic variable x is less then X, i.e. P(x<X).
    def get_cdf(x)
      (1.0 / Math::PI) * Math.atan((x - @location) / @scale) + 0.5   
    end

    # Private method to obtain single inverse CDF value.
    # return the value X for which P(x<X).
    def get_icdf(p) 
      check_range(p)
      @location + @scale * Math.tan(Math::PI * (p - 0.5))
    end

    # Private method to obtain single RNG value.
    def get_rng   
      self.icdf(Kernel.rand)
    end

  end
end
