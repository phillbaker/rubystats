$LOAD_PATH << File.expand_path("../lib", __FILE__)
require 'rubystats/version'

Gem::Specification.new do |s|
  s.name        = 'rubystats'
  s.version     = Rubystats::VERSION
  s.summary     = ''
  s.description = "Ruby Stats is a port of the statistics libraries from PHPMath. Probability distributions include binomial, beta, and normal distributions with PDF, CDF and inverse CDF as well as Fisher's Exact Test."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- Appraisals {test,spec,features,gemfiles}/*`.split("\n")

  s.require_paths = ['lib']
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  s.authors = ['Ilya Scharrenbroich', 'Bryan Donovan - http://www.bryandonovan.com', 'Phillip Baker']

  s.homepage = 'https://github.com/phillbaker/rubystats'

  s.add_development_dependency("rspec", "~> 2.0")
  s.add_development_dependency("hoe", ">= 1.7.0")
end

