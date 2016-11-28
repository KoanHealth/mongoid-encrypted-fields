require 'active_support/concern'

module Mongoid
  module UnsearchableEncryptedField
    extend ActiveSupport::Concern

    def unsearchable?
      true
    end

    module ClassMethods
      def encrypt(plaintext)
        encrypted = EncryptedFields.unsearchable_cipher.encrypt(plaintext).chomp
        Mongoid::EncryptedField::MARKER + encrypted
      end

      def decrypt(encrypted)
        unmarked = encrypted.slice(Mongoid::EncryptedField::MARKER.size..-1)
        EncryptedFields.unsearchable_cipher.decrypt(unmarked)
      end

      def unsearchable?
        true
      end

    end

  end
end

