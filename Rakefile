require 'rake/testtask'
require 'bundler/gem_tasks'

Rake::TestTask.new('test') do |t|
  t.pattern = 'test/**/*_test.rb'
end

desc 'Run a Ruby console with gamesdb already loaded'
task :console do
  require 'irb'
  require 'irb/completion'
  require 'thegamesdb'
  ARGV.clear
  IRB.start
end

task default: 'test'
