require "base64"

module Mongoid
  module EncryptedField
    extend ActiveSupport::Concern

    def encrypted
      if (self.try(:frozen?))
        @encrypted ||= self.class.encrypt(self.to_s)
      else
        # We are mutable - need to encrypt whenever asked
        self.class.encrypt(self.to_s)
      end
    end

    # Converts an object of this instance into a database friendly value.
    def mongoize
      encrypted
    end

    module ClassMethods

      # Used to identify encrypted strings
      MARKER = Base64.encode64('\x02`{~MeF~}`\x03')

      def encrypt(plaintext)
        unmarked = EncryptedFields.cipher.encrypt(plaintext)
        MARKER + unmarked
      end

      def decrypt(encrypted)
        unmarked = encrypted.slice(MARKER.size..-1)
        EncryptedFields.cipher.decrypt(unmarked)
      end

      def is_encrypted?(object)
        object.is_a?(::String) && object.start_with?(MARKER)
      end

    end

  end
end