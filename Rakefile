$:.unshift File.expand_path("..", __FILE__)

require 'rake'
require 'rake/testtask'
require_relative 'modules'

####################### Constants ########################
APP_SCRIPT = 'lib/app.rb'
##########################################################

desc "Run all tests by default"
task default: %w(test)

puts "Modules found: #{MODULES}"

desc "Run all tests"
task :test do
	puts ">>>> Running task test..."
	errors = []
	MODULES.each do |project|
		puts ">>>> Running tests for module '#{project}'"	
		system(%(cd #{project} && #{$0} test --trace)) || errors << project
	end
	fail("Errors in #{errors.join(', ')}") unless errors.empty?	
end

desc "Run the sample application"
task :run do
	errors = []
	system(%(ruby #{APP_SCRIPT} )) || errors 
	fail("Errors in #{errors.join(', ')}") unless errors.empty?	
end
