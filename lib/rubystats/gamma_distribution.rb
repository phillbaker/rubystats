require 'rubystats/normal_distribution'
require 'rubystats/probability_distribution'
module Rubystats
  class GammaDistribution < Rubystats::ProbabilityDistribution
    include Rubystats::NumericalConstants
    include Rubystats::SpecialMath
   
    def initialize(shape=1.0, scale=1.0) 
      if shape <= 0.0 || scale <= 0.0
        raise ArgumentError.new("Input parameter should be greater than zero.")
      end
      @shape = shape.to_f 
      @scale = scale.to_f 
    end

    private

    def get_mean 
      @scale * @shape 
    end

    def get_variance 
      @shape * (@scale)**2
    end

    # Private method to obtain single PDF value.
    # x should be greater than or equal to 0.0  
    # returns the probability that a stochastic variable x has the value X, i.e. P(x=X). 
    def get_pdf(x) 
      check_range(x, 0.0, MAX_VALUE)
      1.0 / (Math.gamma(@shape) * (@scale**@shape)) * (x**(@shape-1.0)) * Math.exp(-1.0 * x / @scale)
    end

    # Private method to obtain single CDF value.
    # param x should be greater than 0    
    # return the probability that a stochastic variable x is less then X, i.e. P(x<X).
    def get_cdf(x)
      check_range(x,0.0,MAX_VALUE)
      @scale * incomplete_gamma(@shape, x/@scale) / Math.gamma(@shape)
    end

    # Private method to obtain single inverse CDF value.
    # return the value X for which P(x<X).
    def get_icdf(p) 
      check_range(p)
      raise "Inverse CDF for gamma not implemented yet."
    end

    # Private method to obtain single RNG value.
    # Generate gamma random variate with 
    # Marsaglia's squeeze method.
    def get_rng
      raise "Gamma RNG not working for shape < 1" if @shape < 1.0
      norm = Rubystats::NormalDistribution.new(0,1)
      d = @shape - 1.0 / 3.0
      c = 1.0 / Math.sqrt(9.0 * d)
      MAX_ITERATIONS.times do  
        x = norm.rng
        v = (1.0 + c * x)**(3.0)
        next if v <= 0.0
        u = Kernel.rand
        if (u < 1.0 - 0.03331 * (x**4)) || (Math.log(u) < 0.5 * x**2 + d * (1.0 - v + Math.log(v)))
          return (d * v) * @scale   
        end
      end 
      raise "Gamma RNG not converged after max_iterations = #{MAX_ITERATIONS}" 
    end

  end
end
