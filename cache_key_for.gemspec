# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'cache_key_for/version'

Gem::Specification.new do |s|
  s.name        = 'cache_key_for'
  s.version     = CacheKeyFor::VERSION.dup
  s.authors     = ['Marcin Kalita']
  s.email       = ['mkalita@efigence.com']

  s.summary     = %q{Comprehensive cache key generator (complements Rails `cache` helper)}
  s.description = %q{How to design a perfect cache key? This project's goal is to provide a bulletproof solution for most use cases.}
  s.homepage    = 'http://github.com/efigence/cache_key_for'
  s.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  #s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.files         = [ ".gitignore",
                      ".rspec",
                      ".travis.yml",
                      "Appraisals",
                      "CODE_OF_CONDUCT.md",
                      "Gemfile",
                      "Gemfile.lock",
                      "LICENSE.txt",
                      "README.md",
                      "Rakefile",
                      "bin/console",
                      "bin/setup",
                      "cache_key_for.gemspec",
                      "gemfiles/rails_4.1.0.gemfile",
                      "gemfiles/rails_4.2.0.gemfile",
                      "lib/cache_key_for.rb",
                      "lib/cache_key_for/cache_key_for_helper.rb",
                      "lib/cache_key_for/cache_key_for_view_helper.rb",
                      "lib/cache_key_for/railtie.rb",
                      "lib/cache_key_for/version.rb" ]
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency('appraisal', '~> 1.0')
  s.add_development_dependency('sqlite3', '~> 1.3')
  s.add_development_dependency('rspec-rails', '~> 3.1')
  s.add_development_dependency('coveralls', '~> 0.8.13')
  s.add_development_dependency('simplecov', '~> 0.11.2')
  s.add_development_dependency('pry', '~> 0.10.3')
  s.add_development_dependency('pry-byebug', '~> 3.3.0')
end
