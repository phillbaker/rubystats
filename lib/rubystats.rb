require 'rubystats/normal_distribution'
require 'rubystats/binomial_distribution'
require 'rubystats/beta_distribution'
require 'rubystats/fishers_exact_test'
require 'rubystats/exponential_distribution'
require 'rubystats/uniform_distribution'
require 'rubystats/lognormal_distribution'
require 'rubystats/student_t_distribution'
require 'rubystats/weibull_distribution'
require 'rubystats/cauchy_distribution'
require 'rubystats/gamma_distribution'
require 'rubystats/version'

module Rubystats
end

NormalDistribution = Rubystats::NormalDistribution
BinomialDistribution = Rubystats::BinomialDistribution
BetaDistribution = Rubystats::BetaDistribution
FishersExactTest = Rubystats::FishersExactTest
ExponentialDistribution = Rubystats::ExponentialDistribution
UniformDistribution = Rubystats::UniformDistribution
LognormalDistribution = Rubystats::LognormalDistribution
StudentTDistribution = Rubystats::StudentTDistribution
WeibullDistribution = Rubystats::WeibullDistribution
CauchyDistribution = Rubystats::CauchyDistribution
GammaDistribution = Rubystats::GammaDistribution

#short-hand notation
Normal = Rubystats::NormalDistribution
Binomial = Rubystats::BinomialDistribution
Beta = Rubystats::BetaDistribution
Exponential = Rubystats::ExponentialDistribution
Uniform = Rubystats::UniformDistribution
Lognormal = Rubystats::LognormalDistribution
Weibull = Rubystats::WeibullDistribution
Cauchy = Rubystats::CauchyDistribution
Gamma = Rubystats::GammaDistribution
