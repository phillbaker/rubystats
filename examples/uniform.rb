$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubystats/normal_distribution'

#normal distribution with mean of 10 and standard deviation of 2
norm = Rubystats::NormalDistribution.new(10, 2)
cdf = norm.cdf(11)
pdf = norm.pdf(11)
puts "CDF(11): #{cdf}"
puts "PDF(11): #{pdf}"

puts "Random numbers from normal distribution:"
10.times do 
  puts norm.rng
end
