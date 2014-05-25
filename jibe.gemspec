# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jibe/version'

Gem::Specification.new do |spec|
  spec.name          = "jibe"
  spec.version       = Jibe::VERSION
  spec.authors       = ["Dallas Read"]
  spec.email         = ["dallas@excitereative.ca"]
  spec.summary       = %q{Jibe keeps all your data 'n sync!}
  spec.description   = %q{Jibe keeps your pages live - with almost no effort!}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
