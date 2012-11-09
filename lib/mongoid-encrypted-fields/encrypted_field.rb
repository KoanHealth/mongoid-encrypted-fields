module Mongoid
  module EncryptedField
    extend ActiveSupport::Concern

    def encrypted
      if (self.try(:frozen?))
        @encrypted ||= self.to_s.encrypt(:symmetric)
      else
        # We are mutable - need to encrypt whenever asked
        self.to_s.encrypt(:symmetric)
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