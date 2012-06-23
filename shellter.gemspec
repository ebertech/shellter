# -*- encoding: utf-8 -*-
require File.expand_path('../lib/shellter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andrew Eberbach"]
  gem.email         = ["andrew@ebertech.ca"]
  gem.description   = %q{A library to help with command line launching}
  gem.summary       = %q{A rounder wheel version of its predecessors.}
  gem.homepage      = "https://github.com/ebertech/shellter"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "shellter"
  gem.require_paths = ["lib"]
  gem.version       = Shellter::VERSION
  
  gem.add_dependency "popen4"
  gem.add_dependency "escape"
  
  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-doc"
  gem.add_development_dependency "pry-nav"
  gem.add_development_dependency "simplecov"
end
