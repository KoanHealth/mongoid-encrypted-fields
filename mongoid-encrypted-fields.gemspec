# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid-encrypted-fields/version'

Gem::Specification.new do |gem|
  gem.name          = "mongoid-encrypted-fields"
  gem.version       = Mongoid::Encrypted::Fields::VERSION
  gem.authors       = ["Jerry Clinesmith"]
  gem.email         = ["jerry.clinesmith@koanhealth.com"]
  gem.description   = "A library for storing encrypted data in Mongo"
  gem.summary       = "Custom types for storing encrypted data"
  gem.homepage      = "https://github.com/KoanHealth/mongoid-encrypted-fields"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "mongoid", "~> 3"
  gem.add_dependency "encrypted_strings"

  gem.add_development_dependency "rspec"
end
