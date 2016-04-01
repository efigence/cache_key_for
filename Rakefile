require 'bundler/setup'
require 'bundler/gem_tasks'
require 'appraisal'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default do
  if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
    exec 'rake spec'
  else
    Rake::Task['appraise'].execute
  end
end

task appraise: ['appraisal:install'] do
  exec 'rake appraisal'
end
