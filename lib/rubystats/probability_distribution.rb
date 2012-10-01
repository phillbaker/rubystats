require 'rubystats/modules'

module Rubystats
  # The ProbabilityDistribution superclass provides an object 
  # for encapsulating probability distributions.
  # 
  # Author: Jaco van Kooten 
  # Author: Mark Hale 
  # Author: Paul Meagher 
  # Author: Jesus Castagnetto 
  # Author: Bryan Donovan (port from PHPmath to Ruby) 
  
  class ProbabilityDistribution
    include Rubystats::NumericalConstants
    include Rubystats::SpecialMath
    include Rubystats::ExtraMath

    def initialize
    end

    #returns the distribution mean
    def mean
      get_mean
    end

    #returns distribution variance
    def variance
      get_variance
    end

    #Probability density function 
    def pdf(x) 
      if x.class == Array
        pdf_vals = []
        for i in (0 ... x.length)
          pdf_vals[i] = get_pdf(x[i])
        end
        return pdf_vals
      else
        return get_pdf(x)
      end
    end

    #Cummulative distribution function
    def cdf(x)
      if x.class == Array
        cdf_vals = []
        for i in (0...x.size)
          cdf_vals[i] = get_cdf(x[i])
        end
        return cdf_vals
      else
        return get_cdf(x)
      end
    end

    #Inverse CDF
    def icdf(p)
      if p.class == Array
        inv_vals = []
        for i in (0..p.length)
          inv_vals[i] = get_icdf(p[i])
        end
        return inv_vals
      else
        return get_icdf(p)
      end
    end

    #Returns random number(s) using subclass's get_rng method 
    def rng(n=1)
      if n < 1
        return "Number of random numbers to return must be 1 or greater"
      end
      if (n > 1)
        rnd_vals = []
        for i in (0..n)
          rnd_vals[i] = get_rng()
        end
        return rnd_vals
      else
        return get_rng()
      end
    end


    private

    #private method to be implemented in subclass
    def get_mean
    end

    #private method to be implemented in subclass
    def get_variance
    end

    #private method to be implemented in subclass
    #returns the probability that a stochastic variable x has the value X, i.e. P(x=X). 
    def get_pdf(x)
    end

    #private method to be implemented in subclass
    #returns the probability that a stochastic variable x is less then X, i.e. P(x&lt;X). 
    def get_cdf(x)
    end

    #private method to be implemented in subclass
    #returns the value X for which P(x&lt;X). 
    def get_icdf(p)
    end

    #private method to be implemented in subclass
    #Random number generator
    def get_rng 
    end

    
    public

    #check that variable is between lo and hi limits. 
    #lo default is 0.0 and hi default is 1.0
    def check_range(x, lo=0.0, hi=1.0)
      raise ArgumentError.new("x cannot be nil") if x.nil?
      if x < lo or x > hi
        raise ArgumentError.new("x must be less than lo (#{lo}) and greater than hi (#{hi})") 
      end
    end

    def get_factorial(n)
      if n <= 1
        return 1
      else 
        return n * get_factorial(n-1)
      end
    end

    def find_root(prob, guess, x_lo, x_hi) 
      accuracy = 1.0e-10
      max_iteration = 150
      x 		= guess
      x_new = guess
      error = 0.0
      _pdf 	= 0.0
      dx 		= 1000.0
      i 		= 0
      while ( dx.abs > accuracy && (i += 1) < max_iteration )
        #Apply Newton-Raphson step
        error = cdf(x) - prob
        if error < 0.0
          x_lo = x
        else
          x_hi = x
        end
        _pdf = pdf(x)
        if _pdf != 0.0
          dx = error / _pdf
          x_new = x -dx
        end
        # If the NR fails to converge (which for example may be the 
        # case if the initial guess is too rough) we apply a bisection
        # step to determine a more narrow interval around the root.
        if  x_new < x_lo || x_new > x_hi || _pdf == 0.0
          x_new = (x_lo + x_hi) / 2.0
          dx = x_new - x
        end
        x = x_new
      end
      return x
    end
  end
end
