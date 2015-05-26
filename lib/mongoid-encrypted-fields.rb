require 'mongoid-encrypted-fields/version'
require 'mongoid-encrypted-fields/logging'
require 'mongoid-encrypted-fields/fields/encrypted_field'
require 'mongoid-encrypted-fields/fields/encrypted_hash'
require 'mongoid-encrypted-fields/fields/encrypted_string'
require 'mongoid-encrypted-fields/fields/encrypted_date'
require 'mongoid-encrypted-fields/fields/encrypted_date_time'
require 'mongoid-encrypted-fields/fields/encrypted_time'

module Mongoid
  module EncryptedFields

    class << self
      # Set cipher used for all field encryption/decryption
      attr_accessor :cipher

      def mongoid_major_version
        @mongoid_major_version ||= ::Mongoid::VERSION[/([^\.]+)/].to_i
      end

    end

  end
end

case ::Mongoid::EncryptedFields.mongoid_major_version
  when 3
    require 'mongoid-encrypted-fields/mongoid3/validations/uniqueness'
  when 4, 5
    require 'mongoid-encrypted-fields/mongoid4/validatable/uniqueness'
  else
    raise "Unsupported version of Mongoid: #{::Mongoid::VERSION::MAJOR}"
end