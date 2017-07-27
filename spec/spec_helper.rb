require 'simplecov'
SimpleCov.start
SimpleCov.minimum_coverage 100

require 'rspec'
require 'bundler'
require 'shoulda-matchers'
require 'byebug'

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jwt-me'

Bundler.load
