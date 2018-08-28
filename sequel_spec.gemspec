# coding: utf-8
$: << File.expand_path('../lib', __FILE__)

require 'sequel_spec/version'

Gem::Specification.new do |spec|
  spec.name          = "sequel_spec"
  spec.version       = SequelSpec::VERSION
  spec.authors       = ["Adrià Planas", "Jonathan Tron", "Joseph Halter"]
  spec.email         = ["adriaplanas@edgecodeworks.com"]
  spec.summary       = %q{RSpec Matchers for Sequel}
  spec.homepage      = "https://github.com/planas/sequel_spec"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep('spec')
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sequel", ">= 4.0", '< 6.0'
  spec.add_runtime_dependency "rspec", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "sqlite3"
end
