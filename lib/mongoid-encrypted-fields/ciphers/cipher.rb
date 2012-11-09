module Mongoid
  module Ciphers
    class Cipher

      def encrypt(data)
        raise NotImplementedError.new('encrypt must be implemented')
      end

      def decrypt(data)
        raise NotImplementedError.new('decrypt must be implemented')
      end

    end
  end
end
