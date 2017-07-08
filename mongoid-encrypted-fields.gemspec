# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid-encrypted-fields/version'

Gem::Specification.new do |gem|
  gem.name          = 'mongoid-encrypted-fields'
  gem.version       = Mongoid::EncryptedFields::VERSION
  gem.authors       = ['Koan Health']
  gem.email         = ['development@koanhealth.com']
  gem.description   = 'A library for storing encrypted data in Mongo'
  gem.summary       = 'Custom types for storing encrypted data'
  gem.homepage      = 'https://github.com/KoanHealth/mongoid-encrypted-fields'
  gem.license       = "MIT"

  gem.required_ruby_version     = ">= 1.9"
  gem.required_rubygems_version = ">= 1.3.6"

  gem.files         = Dir.glob("lib/**/*") + %w(CHANGELOG.md LICENSE.txt README.md Rakefile)
  gem.test_files    = Dir.glob("spec/**/*")
  gem.require_path  = 'lib'

  gem.add_dependency 'mongoid', '>= 3'
  gem.add_dependency 'json', '< 2' if RUBY_VERSION < '2.0'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  if RUBY_VERSION < '2.0'
    gem.add_development_dependency 'gibberish', '< 2'
  else
    gem.add_development_dependency 'gibberish'
  end
  gem.add_development_dependency 'encrypted_strings', '~> 0.3'
  gem.add_development_dependency 'simplecov'
end
