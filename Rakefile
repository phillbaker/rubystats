require 'rubygems'
require 'bundler'
require 'rake'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

desc 'Default: run the specs and features.'
task :default => 'test'

Rake::TestTask.new('test') do |t|
  t.libs << 'test'
  t.test_files = FileList['test/tc*.rb']
  t.verbose = true
end
