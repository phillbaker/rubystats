$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubystats/beta_distribution'

def get_lower_limit(trials,alpha,p)
	if p == 0
		lcl = 0
	else 
		q = trials - p + 1
		bet = Rubystats::BetaDistribution.new(p,q)
		lcl = bet.icdf(alpha)
	end
	return lcl
end

def get_upper_limit(trials,alpha,p)
	q = trials - p
	p = p + 1
	bet = Rubystats::BetaDistribution.new(p,q)
	ucl = bet.icdf(1-alpha)
	return ucl
end


trials = 50 
alpha = 0.05 
p = 10 

lcl = get_lower_limit(trials, alpha, p)
ucl = get_upper_limit(trials, alpha, p)

puts "lcl= "
p lcl
puts "ucl= "
p ucl
