require "base64"

module Mongoid
  module EncryptedField
    extend ActiveSupport::Concern

    def encrypted
      if frozen?
        @encrypted ||= self.class.encrypt(to_s)
      else
        # We are mutable - need to encrypt whenever asked
        self.class.encrypt(to_s)
      end
    end

    # Converts an object of this instance into a database friendly value.
    def mongoize
      encrypted
    end

    module ClassMethods

      # Get the object as it was stored in the database, and instantiate this custom class from it.
      def demongoize(object)
        #EncryptedFields.logger.debug "#{name}##{__method__.to_s}: #{object.inspect}"
        case
          when object.is_a?(self.class) || object.blank?
            object
          else
            decrypted = is_encrypted?(object) ? decrypt(object) : object
            convert(decrypted)
        end
      end

      # Takes any possible object and converts it to how it would be stored in the database.
      def mongoize(object)
        #EncryptedFields.logger.debug "#{name}##{__method__.to_s}: #{object.inspect}"
        case
          when object.is_a?(self.class)
            object.mongoize
          when object.blank? || is_encrypted?(object)
            object
          when object.is_a?(Regexp)
            raise NotImplementedError.new("Searching is only possible when using equality")            
          else
            convert(object).mongoize
        end
      end

      # Converts the object that was supplied to a criteria and converts it into a database friendly form.
      alias_method :evolve, :mongoize

      def convert(object)
        raise NotImplementedError.new("convert must be implemented")
      end

      # Used to identify encrypted strings
      MARKER = Base64.encode64('\x02`{~MeF~}`\x03').chomp

      def encrypt(plaintext)
        encrypted = EncryptedFields.cipher.encrypt(plaintext).chomp
        MARKER + encrypted
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
