#! /usr/local/bin/ruby

# Fisher's Exact Test Function Library
#
# Based on JavaScript version created by: Oyvind Langsrud
# Ported to Ruby by Bryan Donovan
module Rubystats
  class FishersExactTest 

    def initialize
      @sn11    = 0.0
      @sn1_    = 0.0
      @sn_1    = 0.0
      @sn      = 0.0
      @sprob   = 0.0

      @sleft   = 0.0
      @sright  = 0.0 
      @sless   = 0.0 
      @slarg   = 0.0

      @left    = 0.0
      @right   = 0.0
      @twotail = 0.0
    end

    # Reference: "Lanczos, C. 'A precision approximation
    # of the gamma function', J. SIAM Numer. Anal., B, 1, 86-96, 1964."
    # Translation of  Alan Miller's FORTRAN-implementation
    # See http://lib.stat.cmu.edu/apstat/245
    def lngamm(z) 
      x = 0
      x += 0.0000001659470187408462/(z+7)
      x += 0.000009934937113930748 /(z+6)
      x -= 0.1385710331296526      /(z+5)
      x += 12.50734324009056       /(z+4)
      x -= 176.6150291498386       /(z+3)
      x += 771.3234287757674       /(z+2)
      x -= 1259.139216722289       /(z+1)
      x += 676.5203681218835       /(z)
      x += 0.9999999999995183

      return(Math.log(x)-5.58106146679532777-z+(z-0.5) * Math.log(z+6.5))
    end

    def lnfact(n)
      if n <= 1
        return 0
      else
        return lngamm(n+1)
      end
    end

    def lnbico(n,k)
      return lnfact(n) - lnfact(k) - lnfact(n-k)
    end

    def hyper_323(n11, n1_, n_1, n)
      return Math.exp(lnbico(n1_, n11) + lnbico(n-n1_, n_1-n11) - lnbico(n, n_1))
    end

    def hyper(n11)
      return hyper0(n11, 0, 0, 0)
    end

    def hyper0(n11i,n1_i,n_1i,ni)
      if n1_i == 0 and n_1i ==0 and ni == 0
        unless n11i % 10 == 0
          if n11i == @sn11+1
            @sprob *= ((@sn1_ - @sn11)/(n11i.to_f))*((@sn_1 - @sn11)/(n11i.to_f + @sn - @sn1_ - @sn_1))
            @sn11 = n11i
            return @sprob
          end
          if n11i == @sn11-1
            @sprob *= ((@sn11)/(@sn1_-n11i.to_f))*((@sn11+@sn-@sn1_-@sn_1)/(@sn_1-n11i.to_f))
            @sn11 = n11i
            return @sprob
          end
        end
        @sn11 = n11i
      else
        @sn11 = n11i
        @sn1_ = n1_i
        @sn_1 = n_1i
        @sn   = ni
      end
      @sprob = hyper_323(@sn11,@sn1_,@sn_1,@sn)
      return @sprob
    end

    def exact(n11,n1_,n_1,n)

      p = i = j = prob = 0.0

      max = n1_
      max = n_1 if n_1 < max
      min = n1_ + n_1 - n
      min = 0 if min < 0

      if min == max
        @sless  = 1
        @sright = 1
        @sleft  = 1
        @slarg  = 1
        return 1
      end

      prob = hyper0(n11,n1_,n_1,n)
      @sleft = 0

      p = hyper(min)
      i = min + 1
      while p < (0.99999999 * prob)
        @sleft += p
        p = hyper(i)
        i += 1
      end

      i -= 1

      if p < (1.00000001*prob)
        @sleft += p
      else 
        i -= 1	
      end

      @sright = 0

      p = hyper(max)
      j = max - 1
      while p < (0.99999999 * prob)
        @sright += p
        p = hyper(j)
        j -= 1
      end
      j += 1

      if p < (1.00000001*prob)
        @sright += p
      else 
        j += 1
      end

      if (i - n11).abs < (j - n11).abs 
        @sless = @sleft
        @slarg = 1 - @sleft + prob
      else
        @sless = 1 - @sright + prob
        @slarg = @sright
      end
      return prob
    end

    def calculate(n11_,n12_,n21_,n22_)
      n11_ *= -1 if n11_ < 0
      n12_ *= -1 if n12_ < 0
      n21_ *= -1 if n21_ < 0 
      n22_ *= -1 if n22_ < 0 
      n1_     = n11_ + n12_
      n_1     = n11_ + n21_
      n       = n11_ + n12_ + n21_ + n22_
      prob    = exact(n11_,n1_,n_1,n)
      left    = @sless
      right   = @slarg
      twotail = @sleft + @sright
      twotail = 1 if twotail > 1
      values_hash = { :left =>left, :right =>right, :twotail =>twotail }
      return values_hash
    end
  end
end
