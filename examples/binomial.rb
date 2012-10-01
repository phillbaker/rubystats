$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubystats/binomial_distribution'

t = 100
f = 7 
p = 0.05


bin = Rubystats::BinomialDistribution.new(t,p)
f = f - 1
mean = bin.mean
puts mean

for i in 1..12
  pdf = bin.pdf(i)
  cdf = bin.cdf(i)
  inv = bin.icdf(cdf)
  pval = 1 - cdf
  #	puts inv
  puts "#{i}: #{pdf} : #{cdf}: pval: #{pval}"
end

