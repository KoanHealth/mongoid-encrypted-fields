require 'rubygems'
require 'bundler/setup'
require 'mongoid'
require 'rspec'

require 'coveralls'
Coveralls.wear!

require 'mongoid-encrypted-fields'

Dir["#{File.dirname(__FILE__)}/../examples/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

ENV['MONGOID_ENV'] ||= 'test'
Mongoid.load!("#{File.dirname(__FILE__)}/config/mongoid.yml")

Mongoid::EncryptedFields.logger.level = Logger::FATAL

RSpec.configure do |config|
  Mongoid.logger = Mongoid::EncryptedFields.logger
  Moped.logger = Mongoid::EncryptedFields.logger

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
