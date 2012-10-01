# -*- ruby -*-

require 'rubygems'
require 'hoe'
$:.unshift(File.dirname(__FILE__) + "/lib")
require 'rubystats'
#require './lib/rubystats.rb'

Hoe.new('rubystats', Rubystats::VERSION) do |p|
  p.name = "rubystats"
  p.author = "Bryan Donovan - http://www.bryandonovan.com"
  p.email = "b.dondo+rubyforge@gmail.com"
  p.description = "Ruby Stats is a port of the statistics libraries from PHPMath. Probability distributions include binomial, beta, and normal distributions with PDF, CDF and inverse CDF as well as Fisher's Exact Test."
  p.summary = "Port of PHPMath to Ruby"
  p.url = "http://rubyforge.org/projects/rubystats/"
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.remote_rdoc_dir = '' # Release to root
end

desc "Run all tests"
task :test  do 
  Rake::TestTask.new("test") do |t|
    t.test_files = FileList['test/tc*.rb']
    t.verbose = false
  end
end

#Use Allison template if available
ALLISON = "/opt/local/lib/ruby/gems/1.8/gems/allison-2.0.3/lib/allison.rb"

Rake::RDocTask.new do |rd|  
  rd.main = "README.txt"  
  rd.rdoc_dir = "doc"  
  rd.rdoc_files.include(  
      "README.txt",  
      "History.txt",  
      "Manifest.txt",  
      "lib/**/*.rb",
      "examples/**/*.rb",
      "test/**/*.rb")  
  rd.title = "Rubystats RDoc"  

  rd.options << '-S' # inline source  

  rd.template = ALLISON if File.exist?(ALLISON)  
end  

# vim: syntax=Ruby
