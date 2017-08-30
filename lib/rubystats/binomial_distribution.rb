require 'rubystats/probability_distribution'
# This class provides an object for encapsulating binomial distributions
# Ported to Ruby from PHPMath class by Bryan Donovan
# Author:: Mark Hale
# Author:: Paul Meagher
# Author:: Bryan Donovan (http://www.bryandonovan.com)
module Rubystats
  class BinomialDistribution < Rubystats::ProbabilityDistribution 
    include Rubystats::NumericalConstants
    include Rubystats::SpecialMath
    include Rubystats::ExtraMath
    include Rubystats::MakeDiscrete

    attr_reader :p, :n
    attr_writer :p, :n

    # Constructs a binomial distribution
    def initialize (trials, prob)
      if trials <= 0
        raise ArgumentError.new("Error: trials must be greater than 0")
      end
      @n = trials.to_i
      if prob < 0.0 || prob > 1.0
        raise ArgumentError.new("prob must be between 0 and 1")
      end
      @p = prob.to_f
    end

    #returns the number of trials
    def get_trials_parameter
      @n
    end

    #returns the probability
    def get_probability_parameter
      @p
    end

    #returns the mean
    def get_mean
      @n * @p
    end

    #returns the variance
    def get_variance
      @n * @p * (1.0 - @p)
    end

    # Private methods below

    private

    # Probability density function of a binomial distribution (equivalent
    # to R dbinom function).
    # _x should be an integer
    # returns the probability that a stochastic variable x has the value _x,
    # i.e. P(x = _x)
    def get_pdf(x)
      check_range(x, 0, @n)
      binomial(@n, x) * @p**x * (1-@p)**(@n-x)
    end

    # Private shared function for getting cumulant for particular x
    # param _x should be integer-valued
    # returns the probability that a stochastic variable x is less than _x
    # i.e P(x < _x)
    def get_cdf(_x)
      check_range(_x, 0.0, @n)
      sum = 0.0
      for i in (0 .. _x) 
        sum = sum + pdf(i)
      end
      return sum
    end

    # Inverse of the cumulative binomial distribution function 
    # (equivalent to R qbinom function).
    # returns the value X for which P(x < _x).
    def get_icdf(prob)
      check_range(prob)
      (find_root(prob, @n/2, 0.0, @n)).floor
    end

    # Private binomial RNG function
    # Original version of this function from Press et al.
    #
    # see http://www.library.cornell.edu/nr/bookcpdf/c7-3.pdf
    #
    # Changed parts having to do with generating a uniformly distributed
    # number in the 0 to 1 range.  Also using instance variables, instead
    # of supplying function with p and n values.  Finally calling port
    # of JSci's log gamma routine instead of Press et al.
    #
    # There are enough non-trivial changes to this function that the
    # port conforms to the Press et al. copyright.
    def get_rng
      nold = -1
      pold = -1
      p = (if @p <= 0.5 then @p else 1.0 - @p end)
      am = @n * p
      if @n < 25
        bnl = 0.0
        (1...@n).each do
          if  Kernel.rand < p 
            bnl = bnl.next
          end
        end
      elsif am < 1.0
        g = Math.exp(-am)
        t = 1.0
        for j in (0 ... @n)
          t = t * Kernel.rand
          break if t < g
        end
        bnl = (if j <= @n then j else @n end)
      else
        if n != nold
          en = @n
          oldg = log_gamma(en + 1.0)
          nold = n
        end
        if p != pold
          pc = 1.0 - p
          plog = Math.log(p)
          pclog = Math.log(pc)
          pold = p
        end
        sq = Math.sqrt(2.0 * am * pc)
        until Kernel.rand <= t do
          until (em >= 0.0 || em < (en + 1.0)) do
            angle = Pi * Kernel.rand
            y = Math.tan(angle)
            em = sq * y + am
          end
          em = em.floor
          t = 1.2 * sq * (1.0 + y * y) * 
          Math.exp(oldg - log_gamma(em + 1.0) - 
          log_gamma(en - em + 1.0) + em * plog + (en - em) * pclog)
        end
        bnl = em
      end
      if p != @p
        bnl = @n - bnl
      end
      return bnl
    end
  end
end
