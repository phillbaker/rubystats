$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubystats/binomial_distribution'

# Manufacturing example.  
# We have 10 different-sized batches of units that
# get tested in our process.  We want to see if,
# at > 95% confidence, the fail rate for any of
# those batches is worse than our goal fail rate
# of 10%

tested = [100, 68, 67, 96, 46, 2, 13, 33, 88, 71] 
failed = [12,  9,  12, 7,  7,  0, 6,  4,  5,  5]

bad_fail_rate = 0.10
alpha = 0.05


for i in 0..9 
  t = tested[i]
  f = failed[i]
  bin = Rubystats::BinomialDistribution.new(t,bad_fail_rate)
  pdf = bin.pdf(f-1)
  cdf = bin.cdf(f-1)
  pval = 1 - cdf
  pval = sprintf("%.3f",pval).to_f
  status = pval <= alpha ? "RED ALERT" : "OK"
  puts "Tested: #{t}\tFailed: #{f}\tpval: #{pval}\tStatus:#{status}" 
end
