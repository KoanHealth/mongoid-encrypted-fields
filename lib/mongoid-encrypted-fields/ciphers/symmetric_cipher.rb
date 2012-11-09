module Mongoid
  module Ciphers
    class SymmetricCipher < Cipher

      attr_reader :algorithm, :password

      def initialize(options = { })
        @options = options
        @options.each { |key, value| instance_variable_set "@#{key}", value }
      end

      def encrypt(data)
        data.encrypt(:symmetric, @options)
      end

      def decrypt(data)
        data.decrypt(:symmetric, @options)
      end

    end
  end
end