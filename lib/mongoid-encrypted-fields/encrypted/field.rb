module Mongoid
  module Encrypted
    module Field
      extend ActiveSupport::Concern

      def encrypted
        if (self.try(:frozen?))
          @encrypted ||= Config.cipher.encrypt(self.to_s)
        else
          # We are mutable - need to encrypt whenever asked
          Config.cipher.encrypt(self.to_s)
        end
      end

      # Converts an object of this instance into a database friendly value.
      def mongoize
        encrypted
      end

      module ClassMethods

        def is_encrypted?(object)
          object.respond_to?(:encrypted?) && object.send(:encrypted?)
        end

      end

    end
  end
end