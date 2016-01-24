# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_snapshot/version'

Gem::Specification.new do |spec|
  spec.name          = "active_snapshot"
  spec.version       = ActiveSnapshot::VERSION
  spec.authors       = ["yui-knk"]
  spec.email         = ["spiketeika@gmail.com"]

  spec.summary       = %q{Create and apply factories snapshots.}
  spec.description   = %q{Create and apply factories snapshots.}
  spec.homepage      = "https://github.com/yui-knk/active_snapshot"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_dependency "activerecord-import"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
