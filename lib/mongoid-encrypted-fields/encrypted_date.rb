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
  class EncryptedDate < Date
    include EncryptedField

    class << self

      def from_date(date)
        EncryptedDate.parse(date.to_s)
      end

      # Get the object as it was stored in the database, and instantiate this custom class from it.
      def demongoize(object)
        case
          when object.is_a?(EncryptedDate) || object.blank?
            object
          else
            EncryptedDate.from_date(object.decrypt(:symmetric).to_date)
        end
      end

      # Takes any possible object and converts it to how it would be stored in the database.
      def mongoize(object)
        case
          when object.is_a?(EncryptedDate)
            object.mongoize
          when is_encrypted?(object)
            object
          else
            EncryptedDate.from_date(object.to_date).mongoize unless object.blank?
        end
      end

      # Converts the object that was supplied to a criteria and converts it into a database friendly form.
      alias_method :evolve, :mongoize

    end
  end
end
