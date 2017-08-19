require 'rubystats/probability_distribution'
module Rubystats
  class WeibullDistribution < Rubystats::ProbabilityDistribution
    include Rubystats::NumericalConstants
   
    def initialize(scale=1.0, shape=1.0) 
      if scale <= 0.0
        raise ArgumentError.new("Scale parameter should be greater than zero.")
      end
      if shape <= 0.0
        raise ArgumentError.new("Shape parameter should be greater than zero.")
      end
      @scale = scale.to_f 
      @shape = shape.to_f 
    end

    private

    def get_mean 
      @scale * Math.gamma(1.0 + 1.0 / @shape) 
    end

    def get_variance 
      @scale**2 * (Math.gamma(1.0 + 2.0 / @shape) - (Math.gamma(1.0 + 1.0 / @shape))**2)
    end

    # Private method to obtain single PDF value.
    # x should be greater than or equal to 0.0  
    # returns the probability that a stochastic variable x has the value X, i.e. P(x=X). 
    def get_pdf(x) 
      check_range(x, 0.0, MAX_VALUE)
      (@shape / @scale) * (x / @scale)**(@shape-1.0) * Math.exp(-1.0 * ((x/@scale)**@shape))
    end

    # Private method to obtain single CDF value.
    # param x should be greater than 0    
    # return the probability that a stochastic variable x is less then X, i.e. P(x<X).
    def get_cdf(x)
      check_range(x,0.0,MAX_VALUE)
      1.0 - Math.exp(-1.0 * ((x.to_f/@scale)**@shape))    
    end

    # Private method to obtain single inverse CDF value.
    # return the value X for which P(x<X).
    def get_icdf(p) 
      check_range(p)
      @scale * (-1.0 * Math.log(1.0 - p.to_f))**(1.0 / @shape)
    end

    # Private method to obtain single RNG value.
    def get_rng   
      self.icdf(Kernel.rand)
    end

  end
end
