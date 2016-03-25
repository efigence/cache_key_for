require 'bundler/setup'
require 'bundler/gem_tasks'
require 'coveralls/rake/task'
Coveralls::RakeTask.new
task :spec_with_coveralls => [:spec, 'coveralls:push']
require 'appraisal'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default do |t|
  if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
    if ENV['CI'] || ENV['TRAVIS']
      exec 'rake spec_with_coveralls'
    else
      exec 'rake spec'
    end
  else
    Rake::Task['appraise'].execute
  end
end

task :appraise => ['appraisal:install'] do |t|
  exec 'rake appraisal'
end
