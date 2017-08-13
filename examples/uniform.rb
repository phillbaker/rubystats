$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubystats/uniform_distribution'

#uniform distribution with lower and upper bound of 0.0 and 1.0
unif = Rubystats::UniformDistribution.new(1.0, 6.0)
cdf = unif.cdf(2.5)
pdf = unif.pdf(2.5)
puts "CDF(2.5): #{cdf}"
puts "PDF(2.5): #{pdf}"

puts "Random numbers from the uniform distribution:"
10.times do 
  puts unif.rng
end
