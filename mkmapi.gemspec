# -*- encoding: utf-8 -*-
require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Arjen Brandenburgh"]
  gem.email = ["arjen.brandenburgh@gmail.com"]
  gem.summary = "Simple MagicCardMarket API v2.0 (MkmapiAPI) library for Ruby"
  gem.description = "Simple MagicCardMarket API v2.0 (MkmapiAPI) library for Ruby"
  gem.homepage = "http://github.com/arjenbrandenburgh/mkmapi"
  gem.license = "MIT"

  gem.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  gem.test_files = `git ls-files -- test/*`.split("\n")
  gem.name = "mkmapi"
  gem.require_paths = ["lib"]
  gem.version = Mkmapi::VERSION

  gem.add_dependency "faraday", "~> 2.12.1"
  gem.add_dependency "oj", "~> 3.16.7"
  gem.add_dependency "simple_oauth", "~> 0.3.1"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rdoc"
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "simplecov"
end
