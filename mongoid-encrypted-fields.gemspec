# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid-encrypted-fields/version'

Gem::Specification.new do |gem|
  gem.name          = "mongoid-encrypted-fields"
  gem.version       = Mongoid::EncryptedFields::VERSION
  gem.authors       = ["Koan Health"]
  gem.email         = ["development@koanhealth.com"]
  gem.description   = "A library for storing encrypted data in Mongo"
  gem.summary       = "Custom types for storing encrypted data"
  gem.homepage      = "https://github.com/KoanHealth/mongoid-encrypted-fields"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport"
  gem.add_dependency "mongoid", "~> 3"
  gem.add_dependency "time"

  gem.add_development_dependency "encrypted_strings", "~> 0.3"
  gem.add_development_dependency "gibberish", "~> 1.2"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
