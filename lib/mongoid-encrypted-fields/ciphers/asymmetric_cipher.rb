module Mongoid
  module Ciphers
    class AsymmetricCipher < Cipher

      attr_reader :algorithm, :password, :public_key_file, :private_key_file

      def initialize(options = {})
        @options = options
        @options.each { |key, value| instance_variable_set "@#{key}", value }
      end

      def encrypt(data)
        data.encrypt(:asymmetric, @options)
      end

      def decrypt(data)
        data.decrypt(:asymmetric, @options)
      end

    end
  end
end