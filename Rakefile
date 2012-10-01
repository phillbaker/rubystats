require 'rubygems'
require 'bundler'
require 'rake'
require 'rake/testtask'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc 'Default: run the specs and features.'
task :default => 'spec:unit'

namespace :spec do
  desc "Run unit specs"
  RSpec::Core::RakeTask.new('unit') do |t|
    t.pattern = 'spec/{*_spec.rb,factory_girl/**/*_spec.rb}'
  end
end

Rake::TestTask.new('test') do |t|
  t.libs << 'test'
  t.test_files = FileList['test/tc*.rb']
  t.verbose = true
end

desc "Run the unit and acceptance specs"
task :spec => ['spec:unit']

