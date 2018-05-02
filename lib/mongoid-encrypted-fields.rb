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
    end
  end
end
