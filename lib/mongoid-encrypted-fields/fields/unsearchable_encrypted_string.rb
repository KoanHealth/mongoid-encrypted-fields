# encoding: utf-8
#
# Used to store an encrypted string in Mongo, using a unique salt, when it is not necessary to find a record by its encrypted value
#
# Usage:
# field :social_security_number, type: Mongoid::EncryptedString
#
# Set with an unencrypted string
# p = Person.new()
# p.social_security_number = '123456789'
#
# Get returns the unencrypted string
# puts p.social_security_number -> '123456789'
#
# Use the encrypted property to see the encrypted value
# puts p.social_security_number.encrypted -> '....'
#
module Mongoid
  class UnsearchableEncryptedString < Mongoid::EncryptedString
    include Mongoid::UnsearchableEncryptedField

    class << self

      def decrypt(encrypted)
        s = super
        s.force_encoding(Encoding::UTF_8) if s
      end

    end
  end
end