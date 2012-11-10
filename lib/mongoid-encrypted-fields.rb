require 'encrypted_strings'

require 'mongoid-encrypted-fields/version'
require 'mongoid-encrypted-fields/ciphers/cipher'
require 'mongoid-encrypted-fields/ciphers/asymmetric_cipher'
require 'mongoid-encrypted-fields/ciphers/symmetric_cipher'
require 'mongoid-encrypted-fields/fields/encrypted_field'
require 'mongoid-encrypted-fields/fields/encrypted_string'
require 'mongoid-encrypted-fields/fields/encrypted_date'

module Mongoid
  module EncryptedFields

    class << self
      # Set cipher used for all field encryption/decryption
      attr_accessor :cipher
    end

  end
end