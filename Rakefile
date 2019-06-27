# frozen_string_literal: true

require 'rake'
require 'rake/testtask'

task default: [:test]

Rake::TestTask.new(:test) do |test|
  test.libs << 'spec'
  test.pattern = 'spec/**/*_spec.rb'
  test.verbose = false
  test.warning = false
end
