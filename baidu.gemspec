# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'baidu/version'

Gem::Specification.new do |spec|
  spec.name          = "baidu"
  spec.version       = Baidu::VERSION
  spec.authors       = ["Dylan Deng"]
  spec.email         = ["dylan@beansmile.com"]
  spec.description   = "ruby gem for baidu apis"
  spec.summary       = "ruby gem for baidu apis"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 2.6"

  spec.add_dependency "activesupport", ">= 3.2.0"
  spec.add_dependency "oauth2"
  spec.add_dependency "rest-client"
end
