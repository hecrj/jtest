# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jtest/version'

Gem::Specification.new do |spec|
  spec.name          = "jtest"
  spec.version       = Jtest::VERSION
  spec.authors       = ["Héctor"]
  spec.email         = ["hector0193@gmail.com"]
  spec.description   = %q{Tool for automatic testing and creating problems from Jutge.org}
  spec.summary       = %q{Tool for automatic testing and creating problems from Jutge.org}
  spec.homepage      = "https://github.com/hecrj/jtest"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/mkrf_conf.rb"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "htmlentities", "~> 4.3.1"
end
