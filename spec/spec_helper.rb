require 'bundler/setup'
require 'simplecov'

if ENV['TRAVIS']
  require 'coveralls'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/examples/'
end

require 'mongoid'
require 'rspec'

require 'mongoid-encrypted-fields'

Dir["#{File.dirname(__FILE__)}/../examples/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ENV['MONGOID_ENV'] ||= 'test'

# Config format changed in mongoid 5
if Mongoid::EncryptedFields.mongoid_major_version < 5
  Mongoid.load!("#{File.dirname(__FILE__)}/config/mongoid.yml")
else
  Mongoid.load!("#{File.dirname(__FILE__)}/config/mongoid5.yml")
end

Mongoid::EncryptedFields.logger.level = Logger::FATAL

RSpec.configure do |config|
  Mongoid.logger = Mongoid::EncryptedFields.logger
  Moped.logger = Mongoid::EncryptedFields.logger if defined? Moped

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
