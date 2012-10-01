$LOAD_PATH << File.expand_path("../lib", __FILE__)
require 'rubystats/version'

Gem::Specification.new do |s|
  s.name        = 'rubystats'
  s.version     = Rubystats::VERSION
  s.summary     = ''
  s.description = ''

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- Appraisals {spec,features,gemfiles}/*`.split("\n")

  s.require_paths = ['lib']
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  s.authors = ['Ilya Scharrenbroich']
  s.email   = ['']

  s.homepage = 'https://github.com/quidproquo/rubystats'

  s.add_development_dependency("rspec",    "~> 2.0")
end

