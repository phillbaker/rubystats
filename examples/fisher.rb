$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubystats/fishers_exact_test'
require 'pp'

tested1 = 20
tested2 = 30
f1 = 10
f2 = 10

t1 = tested1 - f1
t2 = tested2 - f2 

fet = Rubystats::FishersExactTest.new

fisher = fet.calculate(t1,t2,f1,f2)

pp fisher

perc = 100 * (1.0 - fisher[:twotail])

pp perc
