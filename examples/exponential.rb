$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubystats/exponential_distribution'
lmbda = 1
expd = Rubystats::ExponentialDistribution.new(lmbda)
puts expd.pdf(2)
