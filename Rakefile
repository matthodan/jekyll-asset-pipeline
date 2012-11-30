require 'rake'
require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'spec/**/*_spec.rb'
  test.verbose = false
end
