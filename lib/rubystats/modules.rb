module Rubystats

  module ExtraMath
    def binomial (n, k)
      return Math.exp(log_gamma(n + 1.0) - log_gamma(k + 1.0) - log_gamma(n - k + 1.0))
    end
  end

  module NumericalConstants
    MAX_FLOAT = 3.40282346638528860e292
    EPS = 2.22e-16
    MAX_VALUE = 1.2e290
    LOG_GAMMA_X_MAX_VALUE = 2.55e292
    GAMMA_X_MAX_VALUE = 171.624
    SQRT2PI = 2.5066282746310005024157652848110452530069867406099
    SQRT2 = 1.4142135623730950488016887242096980785696718753769
    XMININ = 2.23e-303
    MAX_ITERATIONS = 1000
    PRECISION = 8.88e-016
    TWO_PI = 6.2831853071795864769252867665590057683943387987502
    GAMMA = 0.57721566490153286060651209008240243104215933593992
    GOLDEN_RATIO = 1.6180339887498948482045868343656381177203091798058
  end


  # Ruby port of SpecialMath.php from PHPMath, which is
  # a port of JSci methods found in SpecialMath.java.
  #
  #
  # Ruby port by Bryan Donovan bryandonovan.com
  #
  # Author:: Jaco van Kooten
  # Author:: Paul Meagher
  # Author:: Bryan Donovan
  module SpecialMath

    include Rubystats::NumericalConstants

    @log_gamma_cache_res = 0.0
    @log_gamma_cache_x   = 0.0
    @log_beta_cache_res  = 0.0
    @log_beta_cache_p    = 0.0
    @log_beta_cache_q    = 0.0

    def log_beta(p,q)
      if p != @log_beta_cache_p || q != @log_beta_cache_q 
        @log_beta_cache_p = p
        @log_beta_cache_q = q
        if (p <= 0.0) || (q <= 0.0) || (p + q) > LOG_GAMMA_X_MAX_VALUE
          @log_beta_cache_res = 0.0
        else
          @log_beta_cache_res = log_gamma(p) + log_gamma(q) - log_gamma(p + q)
        end
      end
      return @log_beta_cache_res
    end

    # Gamma function.
    # Based on public domain NETLIB (Fortran) code by W. J. Cody and L. Stoltz<BR>
    # Applied Mathematics Division<BR>
    # Argonne National Laboratory<BR>
    # Argonne, IL 60439<BR>
    # <P>
    # References:
    # <OL>
    # <LI>"An Overview of Software Development for Special Functions", W. J. Cody, Lecture Notes in Mathematics, 506, Numerical Analysis Dundee, 1975, G. A. Watson (ed.), Springer Verlag, Berlin, 1976.
    # <LI>Computer Approximations, Hart, Et. Al., Wiley and sons, New York, 1968.
    # </OL></P><P>
    # From the original documentation:
    # </P><P>
    # This routine calculates the Gamma function for a real argument X.
    # Computation is based on an algorithm outlined in reference 1.
    # The program uses rational functions that approximate the Gamma
    # function to at least 20 significant decimal digits.  Coefficients
    # for the approximation over the interval (1,2) are unpublished.
    # Those for the approximation for X .GE. 12 are from reference 2.
    # The accuracy achieved depends on the arithmetic system, the
    # compiler, the intrinsic functions, and proper selection of the
    # machine-dependent constants.
    # </P><P>
    # Error returns:<BR>
    # The program returns the value XINF for singularities or when overflow would occur.
    # The computation is believed to be free of underflow and overflow.
    # </P>
    # Author:: Jaco van Kooten

    def orig_gamma(x) 
      # Gamma related constants
      g_p = [ -1.71618513886549492533811, 24.7656508055759199108314,
        -379.804256470945635097577, 629.331155312818442661052,
        866.966202790413211295064, -31451.2729688483675254357,
        -36144.4134186911729807069, 66456.1438202405440627855 ]
      g_q = [-30.8402300119738975254353, 315.350626979604161529144,
        -1015.15636749021914166146, -3107.77167157231109440444,
        22538.1184209801510330112, 4755.84627752788110767815,
        -134659.959864969306392456, -115132.259675553483497211 ] 
      g_c = [-0.001910444077728, 8.4171387781295e-4, -5.952379913043012e-4,
        7.93650793500350248e-4, -0.002777777777777681622553,
        0.08333333333333333331554247, 0.0057083835261 ]
      fact = 1.0
      i = 0
      n = 0
      y = x
      parity = false
      if y <= 0.0 
        # ----------------------------------------------------------------------
        #  Argument is negative
        # ----------------------------------------------------------------------
        y = -(x)
        y1 = y.to_i
        res = y - y1
        if res != 0.0 
          if y1 != (((y1*0.5).to_i) * 2.0)
            parity = true
            fact = -M_pi/sin(M_pi * res)
            y += 1
          end
        else
          return MAX_VALUE
        end
      end

      # ----------------------------------------------------------------------
      #  Argument is positive
      # ----------------------------------------------------------------------
      if y < EPS
        # ----------------------------------------------------------------------
        #  Argument .LT. EPS
        # ----------------------------------------------------------------------
        if y >= XMININ
          res = 1.0 / y
        else
          return MAX_VALUE
        end
      elsif y < 12.0
        y1 = y
        #end
        if y < 1.0
          # ----------------------------------------------------------------------
          #  0.0 .LT. argument .LT. 1.0
          # ----------------------------------------------------------------------
          z = y
          y += 1
        else 
          # ----------------------------------------------------------------------
          #  1.0 .LT. argument .LT. 12.0, reduce argument if necessary
          # ----------------------------------------------------------------------
          n = y.to_i - 1
          y -= n.to_f
          z = y - 1.0
        end
        # ----------------------------------------------------------------------
        #  Evaluate approximation for 1.0 .LT. argument .LT. 2.0
        # ----------------------------------------------------------------------
        xnum = 0.0
        xden = 1.0
        for i in (0...8) 
          xnum = (xnum + g_p[i]) * z
          xden = xden * z + g_q[i]
        end
        res = xnum / xden + 1.0
        if y1 < y
          # ----------------------------------------------------------------------
          #  Adjust result for case  0.0 .LT. argument .LT. 1.0
          # ----------------------------------------------------------------------
          res /= y1
        elsif y1 > y 
          # ----------------------------------------------------------------------
          #  Adjust result for case  2.0 .LT. argument .LT. 12.0
          # ----------------------------------------------------------------------
          for i in (0...n)
            res *= y
            y += 1
          end
        end
      else 
        # ----------------------------------------------------------------------
        #  Evaluate for argument .GE. 12.0
        # ----------------------------------------------------------------------
        if y <= GAMMA_X_MAX_VALUE
          ysq = y * y
          sum = g_c[6]
          for i in(0...6) 
            sum = sum / ysq + g_c[i]
            sum = sum / y - y + log(SQRT2PI)
            sum += (y - 0.5) * log(y)
            res = Math.exp(sum)
          end
        else
          return MAX_VALUE
        end
        # ----------------------------------------------------------------------
        #  Final adjustments and return
        # ----------------------------------------------------------------------
        if parity
          res = -res
          if fact != 1.0
            res = fact / res
            return res
          end
        end
      end
    end

    #TODO test this
    def gamma(_x)
      return 0 if _x == 0.0

      p0 = 1.000000000190015
      p = {1 => 76.18009172947146,
      2 => -86.50532032941677,
      3 => 24.01409824083091,
      4 => -1.231739572450155,
      5 => 1.208650973866179e-3,
      6 => -5.395239384953e-6}

      y = x = _x
      tmp = x + 5.5
      tmp -= (x + 0.5) * Math.log(tmp)

      summer = p0
      for j in (1 ... 6)
        y += 1
        summer += (p[j] / y)
      end
      return Math.exp(0 - tmp + Math.log(2.5066282746310005 * summer / x))
    end

    def log_gamma(x)
      lg_d1 = -0.5772156649015328605195174
      lg_d2 = 0.4227843350984671393993777
      lg_d4 = 1.791759469228055000094023

      lg_p1 = [ 4.945235359296727046734888,
        201.8112620856775083915565, 2290.838373831346393026739,
        11319.67205903380828685045, 28557.24635671635335736389,
        38484.96228443793359990269, 26377.48787624195437963534,
        7225.813979700288197698961 ]

      lg_p2 = [ 4.974607845568932035012064,
        542.4138599891070494101986, 15506.93864978364947665077,
        184793.2904445632425417223, 1088204.76946882876749847,
        3338152.967987029735917223, 5106661.678927352456275255,
        3074109.054850539556250927 ]

      lg_p4 = [ 14745.02166059939948905062,
        2426813.369486704502836312, 121475557.4045093227939592,
        2663432449.630976949898078, 29403789566.34553899906876,
        170266573776.5398868392998, 492612579337.743088758812,
        560625185622.3951465078242 ]

      lg_q1 = [ 67.48212550303777196073036,
        1113.332393857199323513008, 7738.757056935398733233834,
        27639.87074403340708898585, 54993.10206226157329794414,
        61611.22180066002127833352, 36351.27591501940507276287,
        8785.536302431013170870835 ]

      lg_q2 = [ 183.0328399370592604055942,
        7765.049321445005871323047, 133190.3827966074194402448,
        1136705.821321969608938755, 5267964.117437946917577538,
        13467014.54311101692290052, 17827365.30353274213975932,
        9533095.591844353613395747 ]

      lg_q4 = [ 2690.530175870899333379843,
        639388.5654300092398984238, 41355999.30241388052042842,
        1120872109.61614794137657, 14886137286.78813811542398,
        101680358627.2438228077304, 341747634550.7377132798597,
        446315818741.9713286462081 ]

      lg_c  = [ -0.001910444077728,8.4171387781295e-4,
        -5.952379913043012e-4, 7.93650793500350248e-4,
        -0.002777777777777681622553, 0.08333333333333333331554247,
        0.0057083835261 ]

      # Rough estimate of the fourth root of logGamma_xBig
      lg_frtbig = 2.25e76
      pnt68     = 0.6796875

      if x == @log_gamma_cache_x
        return @log_gamma_cache_res
      end

      y = x
      if y > 0.0 && y <= LOG_GAMMA_X_MAX_VALUE
        if y <= EPS
          res = -Math.log(y)
        elsif y <= 1.5
          # EPS .LT. X .LE. 1.5
          if y < pnt68
            corr = -Math.log(y)
            # xm1 is x-m-one, not x-m-L
            xm1 = y
          else
            corr = 0.0
            xm1 = y - 1.0
          end
          if y <= 0.5 || y >= pnt68
            xden = 1.0
            xnum = 0.0
            for i in (0...8)
              xnum = xnum * xm1 + lg_p1[i]
              xden = xden * xm1 + lg_q1[i]
            end
            res = corr + xm1 * (lg_d1 + xm1 * (xnum / xden))
          else
            xm2 = y - 1.0
            xden = 1.0
            xnum = 0.0
            for i in (0 ... 8)
              xnum = xnum * xm2 + lg_p2[i]
              xden = xden * xm2 + lg_q2[i]
            end
            res = corr + xm2 * (lg_d2 + xm2 * (xnum / xden))
          end
        elsif y <= 4.0
          # 1.5 .LT. X .LE. 4.0
          xm2 = y - 2.0
          xden = 1.0
          xnum = 0.0
          for i in (0 ... 8)
            xnum = xnum * xm2 + lg_p2[i]
            xden = xden * xm2 + lg_q2[i]
          end
          res = xm2 * (lg_d2 + xm2 * (xnum / xden))
        elsif y <= 12.0
          # 4.0 .LT. X .LE. 12.0
          xm4 = y - 4.0
          xden = -1.0
          xnum = 0.0
          for i in (0 ... 8)
            xnum = xnum * xm4 + lg_p4[i]
            xden = xden * xm4 + lg_q4[i]
          end
          res = lg_d4 + xm4 * (xnum / xden)
        else
          # Evaluate for argument .GE. 12.0
          res = 0.0
          if y <= lg_frtbig
            res = lg_c[6]
            ysq = y * y
            for i in (0...6)
              res = res / ysq + lg_c[i]
            end
          end
          res = res/y
          corr = Math.log(y)
          res = res + Math.log(SQRT2PI) - 0.5 * corr
          res = res + y * (corr - 1.0)
        end
      else
        #return for bad arguments
        res = MAX_VALUE
      end
      # final adjustments and return
      @log_gamma_cache_x = x
      @log_gamma_cache_res = res
      return res
    end


    # Incomplete Gamma function.
    # The computation is based on approximations presented in 
    # Numerical Recipes, Chapter 6.2 (W.H. Press et al, 1992).
    # @param a require a>=0
    # @param x require x>=0
    # @return 0 if x<0, a<=0 or a>2.55E305 to avoid errors and over/underflow
    # @author Jaco van Kooten

    def incomplete_gamma(a, x) 
      if x <= 0.0 || a <= 0.0 || a > LOG_GAMMA_X_MAX_VALUE
        return 0.0
      elsif x < (a + 1.0)
        return gamma_series_expansion(a, x)
      else
        return 1.0-gamma_fraction(a, x)
      end
    end

    # Author:: Jaco van Kooten
    def gamma_series_expansion(a, x)
      ap  = a
      del = 1.0 / a
      sum = del
      for n in (1...MAX_ITERATIONS)
        ap += 1
        del *= x / ap
        sum += del
        if del < sum * PRECISION
          return sum * Math.exp(-x + a * Math.log(x) - log_gamma(a))
        end
      end
      return "Maximum iterations exceeded: please file a bug report."
    end

    # Author:: Jaco van Kooten
    def gamma_fraction(a, x) 
      b  = x + 1.0 - a
      c  = 1.0 / XMININ
      d  = 1.0 / b
      h  = d
      del= 0.0
      an = 0.0
      for i in (1...MAX_ITERATIONS) 
        if (del-1.0).abs > PRECISION
          an = -i * (i - a)
          b += 2.0
          d  = an * d + b
          c  = b + an / c
          if c.abs < XMININ
            c = XMININ
            if d.abs < XMININ
              c = XMININ
              d   = 1.0 / d
              del = d * c
              h  *= del
            end
          end
        end
        return Math.exp(-x + a * Math.log(x) - log_gamma(a)) * h
      end
    end

    # Beta function.
    #
    # Author:: Jaco van Kooten

    def beta(p, q) 
      if p <= 0.0 || q <= 0.0 || (p + q) > LOG_GAMMA_X_MAX_VALUE
        return 0.0
      else 
        return Math.exp(log_beta(p, q))
      end
    end

    # Incomplete Beta function.
    #
    # Author:: Jaco van Kooten
    # Author:: Paul Meagher
    #
    #  The computation is based on formulas from Numerical Recipes, 
    #  Chapter 6.4 (W.H. Press et al, 1992).

    def incomplete_beta(x, p, q) 
      if x <= 0.0
        return 0.0
      elsif x >= 1.0
        return 1.0
      elsif (p <= 0.0) || (q <= 0.0) || (p + q) > LOG_GAMMA_X_MAX_VALUE
        return 0.0
      else 
        beta_gam = Math.exp( -log_beta(p, q) + p * Math.log(x) + q * Math.log(1.0 - x) )
        if x < (p + 1.0) / (p + q + 2.0)
          return beta_gam * beta_fraction(x, p, q) / p
        else
          return 1.0 - (beta_gam * beta_fraction(1.0 - x, q, p) / q)
        end
      end
    end


    # Evaluates of continued fraction part of incomplete beta function.
    # Based on an idea from Numerical Recipes (W.H. Press et al, 1992).
    # Author:: Jaco van Kooten

    def beta_fraction(x, p, q) 
      c = 1.0
      sum_pq  = p + q
      p_plus  = p + 1.0
      p_minus = p - 1.0
      h = 1.0 - sum_pq * x / p_plus
      if h.abs < XMININ 
        h = XMININ
      end
      h     = 1.0 / h
      frac  = h
      m     = 1
      delta = 0.0

      while (m <= MAX_ITERATIONS) && ((delta - 1.0).abs > PRECISION) 
        m2 = 2 * m
        # even index for d
        d = m * (q - m) * x / ( (p_minus + m2) * (p + m2))
        h = 1.0 + d * h
        if h.abs < XMININ
          h = XMININ
        end
        h = 1.0 / h
        c = 1.0 + d / c
        if c.abs < XMININ
          c = XMININ
        end
        frac *= (h * c)
        # odd index for d
        d = -(p + m) * (sum_pq + m) * x / ((p + m2) * (p_plus + m2))
        h = 1.0 + d * h
        if h.abs < XMININ
          h = XMININ
        end
        h = 1.0 / h
        c = 1.0 + d / c
        if c.abs < XMININ
          c = XMININ
        end
        delta = h * c
        frac *= delta
        m += 1
      end
      return frac
    end



    # Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.
    #
    # Developed at SunSoft, a Sun Microsystems, Inc. business.
    # Permission to use, copy, modify, and distribute this
    # software is freely granted, provided that this notice
    # is preserved.
    #
    #                 x
    #              2      |\
    #     erf(x)  =  ---------  | exp(-t*t)dt
    #            sqrt(pi) \|
    #                 0
    #
    #     erfc(x) =  1-erf(x)
    #  Note that
    #        erf(-x) = -erf(x)
    #        erfc(-x) = 2 - erfc(x)
    #
    # Method:
    #    1. For |x| in [0, 0.84375]
    #        erf(x)  = x + x*R(x^2)
    #          erfc(x) = 1 - erf(x)           if x in [-.84375,0.25]
    #                  = 0.5 + ((0.5-x)-x*R)  if x in [0.25,0.84375]
    #       where R = P/Q where P is an odd poly of degree 8 and
    #       Q is an odd poly of degree 10.
    #                         -57.90
    #            | R - (erf(x)-x)/x | <= 2
    #
    #
    #       Remark. The formula is derived by noting
    #          erf(x) = (2/sqrt(pi))*(x - x^3/3 + x^5/10 - x^7/42 + ....)
    #       and that
    #          2/sqrt(pi) = 1.128379167095512573896158903121545171688
    #       is close to one. The interval is chosen because the fix
    #       point of erf(x) is near 0.6174 (i.e., erf(x)=x when x is
    #       near 0.6174), and by some experiment, 0.84375 is chosen to
    #        guarantee the error is less than one ulp for erf.
    #
    #      2. For |x| in [0.84375,1.25], let s = |x| - 1, and
    #         c = 0.84506291151 rounded to single (24 bits)
    #             erf(x)  = sign(x) * (c  + P1(s)/Q1(s))
    #             erfc(x) = (1-c)  - P1(s)/Q1(s) if x > 0
    #              1+(c+P1(s)/Q1(s))    if x < 0
    #             |P1/Q1 - (erf(|x|)-c)| <= 2**-59.06
    #       Remark: here we use the taylor series expansion at x=1.
    #        erf(1+s) = erf(1) + s*Poly(s)
    #             = 0.845.. + P1(s)/Q1(s)
    #              That is, we use rational approximation to approximate
    #                 erf(1+s) - (c = (single)0.84506291151)
    #            Note that |P1/Q1|< 0.078 for x in [0.84375,1.25]
    #            where
    #             P1(s) = degree 6 poly in s
    #             Q1(s) = degree 6 poly in s
    #     
    #           3. For x in [1.25,1/0.35(~2.857143)],
    #                  erfc(x) = (1/x)*exp(-x*x-0.5625+R1/S1)
    #                  erf(x)  = 1 - erfc(x)
    #            where
    #             R1(z) = degree 7 poly in z, (z=1/x^2)
    #             S1(z) = degree 8 poly in z
    #     
    #           4. For x in [1/0.35,28]
    #                  erfc(x) = (1/x)*exp(-x*x-0.5625+R2/S2) if x > 0
    #                 = 2.0 - (1/x)*exp(-x*x-0.5625+R2/S2) if -6<x<0
    #                 = 2.0 - tiny        (if x <= -6)
    #                  erf(x)  = sign(x)*(1.0 - erfc(x)) if x < 6, else
    #                  erf(x)  = sign(x)*(1.0 - tiny)
    #            where
    #             R2(z) = degree 6 poly in z, (z=1/x^2)
    #             S2(z) = degree 7 poly in z
    #     
    #           Note1:
    #            To compute exp(-x*x-0.5625+R/S), let s be a single
    #            PRECISION number and s := x then
    #             -x*x = -s*s + (s-x)*(s+x)
    #                 exp(-x*x-0.5626+R/S) =
    #                 exp(-s*s-0.5625)*exp((s-x)*(s+x)+R/S)
    #           Note2:
    #            Here 4 and 5 make use of the asymptotic series
    #                   exp(-x*x)
    #             erfc(x) ~ ---------- * ( 1 + Poly(1/x^2) )
    #                   x*sqrt(pi)
    #            We use rational approximation to approximate
    #               g(s)=f(1/x^2) = log(erfc(x)*x) - x*x + 0.5625
    #            Here is the error bound for R1/S1 and R2/S2
    #               |R1/S1 - f(x)|  < 2**(-62.57)
    #               |R2/S2 - f(x)|  < 2**(-61.52)
    #
    #            5. For inf > x >= 28
    #                             erf(x)  = sign(x) *(1 - tiny)  (raise inexact)
    #                             erfc(x) = tiny*tiny (raise underflow) if x > 0
    #                           = 2 - tiny if x<0
    #                
    #            7. Special case:
    #                             erf(0)  = 0, erf(inf)  = 1, erf(-inf) = -1,
    #                             erfc(0) = 1, erfc(inf) = 0, erfc(-inf) = 2,
    #                           erfc/erf(NaN) is NaN
    #               
    #               $efx8 = 1.02703333676410069053e00
    #                
    #                 Coefficients for approximation to erf on [0,0.84375]
    #                

    # Error function.
    # Based on C-code for the error function developed at Sun Microsystems.
    # Author:: Jaco van Kooten

    def error(x)
      e_efx = 1.28379167095512586316e-01

      ePp = [ 1.28379167095512558561e-01,
        -3.25042107247001499370e-01,
        -2.84817495755985104766e-02,
        -5.77027029648944159157e-03,
        -2.37630166566501626084e-05 ]

      eQq = [ 3.97917223959155352819e-01,
        6.50222499887672944485e-02,
        5.08130628187576562776e-03,
        1.32494738004321644526e-04,
        -3.96022827877536812320e-06 ]

      # Coefficients for approximation to erf in [0.84375,1.25]
      ePa = [-2.36211856075265944077e-03,
        4.14856118683748331666e-01,
        -3.72207876035701323847e-01,
        3.18346619901161753674e-01,
        -1.10894694282396677476e-01,
        3.54783043256182359371e-02,
        -2.16637559486879084300e-03 ]

      eQa = [ 1.06420880400844228286e-01,
        5.40397917702171048937e-01,
        7.18286544141962662868e-02,
        1.26171219808761642112e-01,
        1.36370839120290507362e-02,
        1.19844998467991074170e-02 ]

      e_erx = 8.45062911510467529297e-01

      abs_x = (if x >= 0.0 then x else -x end)
      # 0 < |x| < 0.84375
      if abs_x < 0.84375
        #|x| < 2**-28
        if abs_x < 3.7252902984619141e-9 
          retval = abs_x + abs_x * e_efx
        else
          s = x * x
          p = ePp[0] + s * (ePp[1] + s * (ePp[2] + s * (ePp[3] + s * ePp[4])))

          q = 1.0 + s * (eQq[0] + s * (eQq[1] + s *
                                       ( eQq[2] + s * (eQq[3] + s * eQq[4]))))
          retval = abs_x + abs_x * (p / q)
        end
      elsif abs_x < 1.25
        s = abs_x - 1.0
        p = ePa[0] + s * (ePa[1] + s * 
                          (ePa[2] + s * (ePa[3] + s * 
           (ePa[4] + s * (ePa[5] + s * ePa[6])))))

        q = 1.0 + s * (eQa[0] + s * 
                       (eQa[1] + s * (eQa[2] + s * 
           (eQa[3] + s * (eQa[4] + s * eQa[5])))))
        retval = e_erx + p / q

      elsif abs_x >= 6.0
        retval = 1.0
      else
        retval = 1.0 - complementary_error(abs_x)
      end
      return (if x >= 0.0 then retval else -retval end)
    end

  # Complementary error function.
  # Based on C-code for the error function developed at Sun Microsystems.
  # author Jaco van Kooten

   def complementary_error(x)
    # Coefficients for approximation of erfc in [1.25,1/.35]

    eRa = [-9.86494403484714822705e-03,
      -6.93858572707181764372e-01,
      -1.05586262253232909814e01,
      -6.23753324503260060396e01,
      -1.62396669462573470355e02,
      -1.84605092906711035994e02,
      -8.12874355063065934246e01,
      -9.81432934416914548592e00 ]

    eSa = [ 1.96512716674392571292e01,
      1.37657754143519042600e02,
      4.34565877475229228821e02,
      6.45387271733267880336e02,
      4.29008140027567833386e02,
      1.08635005541779435134e02,
      6.57024977031928170135e00,
      -6.04244152148580987438e-02 ]

    # Coefficients for approximation to erfc in [1/.35,28]

    eRb = [-9.86494292470009928597e-03,
      -7.99283237680523006574e-01,
      -1.77579549177547519889e01,
      -1.60636384855821916062e02,
      -6.37566443368389627722e02,
      -1.02509513161107724954e03,
      -4.83519191608651397019e02 ]

    eSb = [ 3.03380607434824582924e01,
      3.25792512996573918826e02,
      1.53672958608443695994e03,
      3.19985821950859553908e03,
      2.55305040643316442583e03,
      4.74528541206955367215e02,
      -2.24409524465858183362e01 ]

    abs_x = (if x >= 0.0 then x else -x end)
    if abs_x < 1.25
      retval = 1.0 - error(abs_x)
    elsif abs_x > 28.0
      retval = 0.0

      # 1.25 < |x| < 28
    else
      s = 1.0/(abs_x * abs_x)
      if abs_x < 2.8571428
        r = eRa[0] + s * (eRa[1] + s * 
                          (eRa[2] + s * (eRa[3] + s * (eRa[4] + s * 
                                                       (eRa[5] + s *(eRa[6] + s * eRa[7])
                                                       )))))

                                                       s = 1.0 + s * (eSa[0] + s * (eSa[1] + s * 
                                          (eSa[2] + s * (eSa[3] + s * (eSa[4] + s * 
                           (eSa[5] + s * (eSa[6] + s * eSa[7])))))))

      else
        r = eRb[0] + s * (eRb[1] + s * 
                          (eRb[2] + s * (eRb[3] + s * (eRb[4] + s * 
             (eRb[5] + s * eRb[6])))))

        s = 1.0 + s * (eSb[0] + s * 
                       (eSb[1] + s * (eSb[2] + s * (eSb[3] + s * 
             (eSb[4] + s * (eSb[5] + s * eSb[6]))))))
      end
      retval =  Math.exp(-x * x - 0.5625 + r/s) / abs_x
    end
    return ( if x >= 0.0 then retval else 2.0 - retval end )
    end
  end
end
