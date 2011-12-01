require 'rubygems'
require 'bundler'
Bundler.setup

require 'ruby-debug' if !defined?(RUBY_ENGINE) && RUBY_VERSION != '1.9.3' && !ENV['CI']

require 'aruba/cucumber'

Before do
  load_paths, requires = ['../../lib'], []

  if RUBY_VERSION < '1.9'
    requires << "rubygems"
  else
    load_paths << '.'
  end

  requires << '../../features/support/vcr_cucumber_helpers'
  requires.map! { |r| "-r#{r}" }
  set_env('RUBYOPT', "-I#{load_paths.join(':')} #{requires.join(' ')}")

  if RUBY_PLATFORM == 'java'
    # ideas taken from: http://blog.headius.com/2010/03/jruby-startup-time-tips.html
    set_env('JRUBY_OPTS', '-X-C') # disable JIT since these processes are so short lived
    set_env('JAVA_OPTS', '-d32') # force jRuby to use client JVM for faster startup times
  end

  @aruba_timeout_seconds = RUBY_PLATFORM == 'java' ? 60 : 20
end

