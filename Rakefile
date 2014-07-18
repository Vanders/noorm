# encoding: utf-8
begin
  require 'bundler/setup'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

begin
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new
rescue LoadError
  task :rubocop do
    abort 'Rubocop is not available.'
  end
end

task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end

task :default do
  Rake::Task['spec'].invoke
  Rake::Task['rubocop'].invoke if defined?(RuboCop)
end
