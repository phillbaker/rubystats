= Rubystats

* http://rubyforge.org/projects/rubystats/

== DESCRIPTION:

 This is a set of Ruby statistics libraries ported from the PHPMath libraries.
 PHPMath libraries created by Paul Meagher (many of which were ported from 
 various sources).
 See http://www.phpmath.com/ for PHPMath libraries.

 Currently includes classes for normal, binomial, beta and exponential distributions, with more
 planned to be added.

 See examples and tests for usage.

== NOTE for version 0.2.0:

 The API has changed somewhat in version 0.2. All tests pass with the old API, but
 You now if you want to load just one of the distributions, you must require it like:

 require 'rubystats/normal_distribution'

 Then prefix the class name with the Rubystats module name:
 norm = Rubystats::NormalDistribution.new(10, 2)
 
 Alternatively, you can simply require 'rubystats' and have all the classes loaded, and 
 have the Rubystats module included.
  

== Author: 
 Bryan Donovan
 2006-2008


== WARNING:
This is beta-quality software. It works well according to my tests, but the API may change and other features may be added.

== FEATURES:
Classes for distributions:

* Normal
* Binomial
* Beta
* Exponential

Also includes Fisher's Exact Test

== SYNOPSIS:
=== Example: normal distribution with mean of 10 and standard deviation of 2

 norm = Rubystats::NormalDistribution.new(10, 2)
 cdf = norm.cdf(11)
 pdf = norm.pdf(11)
 puts "CDF(11): #{cdf}"
 puts "PDF(11): #{pdf}"

Output:
 CDF(11): 0.691462461274013
 PDF(11): 0.0733813315868699

=== Example: get some random numbers from a normal distribution

 puts "Random numbers from normal distribution:"
 10.times do
   puts norm.rng
 end

(sample) Output:

  18.8877297946427
  -15.4463065628574
  4.55538065315298
  17.0281528150355
  3.16543873165151
  2.48599492216993
  14.3947330544886
  -3.47989062859462
  5.05832591294848
  31.2952983108343

== REQUIREMENTS:

* Ruby > 1.8.2 (may work with earlier versions)

== INSTALL:

* sudo gem install rubystats 

== LICENSE:

(The MIT License)

Copyright (c) 2008 

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
