require "bundler/gem_tasks"
require 'rubygems'



# desc "test"
# task :test do
#   sh "ruby -I lib -rubygems test/**/*_test.rb"
# end

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end
