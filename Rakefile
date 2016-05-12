require 'rake/testtask'
require 'bundler/gem_tasks'

Rake::TestTask.new('test') do |t|
  t.pattern = 'test/**/*_test.rb'
end

task :console do
  require 'irb'
  require 'irb/completion'
  require 'gamesdb'
  ARGV.clear
  IRB.start
end

task default: 'test'
