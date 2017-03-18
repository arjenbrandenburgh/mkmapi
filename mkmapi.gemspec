# -*- encoding: utf-8 -*-
require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Arjen Brandenburgh"]
  gem.email         = ["arjen.brandenburgh@gmail.com"]
  gem.summary       = "Simple MagicCardMarket API v2.0 (MkmapiAPI) library for Ruby"
  gem.description   = "Simple MagicCardMarket API v2.0 (MkmapiAPI) library for Ruby"
  gem.homepage      = "http://githib.com/cybey/mkmapi"
  gem.license       = "MIT"

  gem.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "Mkmapi"
  gem.require_paths = ["lib"]
  gem.version       = Mkmapi::VERSION

  gem.add_dependency                  'faraday', '~> 0.11'
  gem.add_dependency                  'oj', '~> 2.18'
  gem.add_dependency                  'simple_oauth', '~> 0.3'

  gem.add_development_dependency      'rspec'
  gem.add_development_dependency      'rdoc'
  gem.add_development_dependency      'bundler'
  gem.add_development_dependency      'simplecov'
  gem.add_development_dependency      'sidekiq'
end
