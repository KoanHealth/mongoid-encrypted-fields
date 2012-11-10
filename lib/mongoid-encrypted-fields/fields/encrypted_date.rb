#
# Used to store a (symmetrically) encrypted date in Mongo
#
# Usage:
# field :birth_date, type: Mongoid::EncryptedDate
#
# Set with an unencrypted date
# p = Person.new()
# p.birth_date = Date.new(2000, 1, 1)
#
# Get returns the unencrypted date
# puts p.birth_date -> 'Jan 1, 2000'
#
# Use the encrypted property to see the encrypted value
# puts p.birth_date.encrypted -> '....'
#
module Mongoid
  class EncryptedDate < ::Date
    include Mongoid::EncryptedField

    class << self

      def from_date(date)
        parse(date.to_s)
      end

      # Get the object as it was stored in the database, and instantiate this custom class from it.
      def demongoize(object)
        EncryptedFields.logger.debug "#{name}##{__method__.to_s}: #{object.inspect}"
        case
          when object.is_a?(Mongoid::EncryptedDate) || object.blank?
            object
          else
            decrypted = is_encrypted?(object) ? decrypt(object) : object
            from_date(decrypted.to_date)
        end
      end

      # Takes any possible object and converts it to how it would be stored in the database.
      def mongoize(object)
        EncryptedFields.logger.debug "#{name}##{__method__.to_s}: #{object.inspect}"
        case
          when object.is_a?(Mongoid::EncryptedDate)
            object.mongoize
          when object.nil? || is_encrypted?(object)
            object
          else
            from_date(object.to_date).mongoize
        end
      end

      # Converts the object that was supplied to a criteria and converts it into a database friendly form.
      alias_method :evolve, :mongoize

    end
  end
end