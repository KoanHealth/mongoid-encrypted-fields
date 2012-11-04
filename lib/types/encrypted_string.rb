#
# Used to store a (symmetrically) encrypted string in Mongo
#
# Usage:
# field :social_security_number, type: EncryptedString
#
# Set with an unencrypted string
# p = Person.new()
# p.social_security_number = '123456789'
#
# Get returns the unencrypted string
# puts p.social_security_number -> '123456789'
#
# Use the encrypted property to see the encrypted value (depends on password)
# puts p.social_security_number.encrypted -> '....'
#
class EncryptedString < String

  attr_reader :encrypted

  def initialize(raw)
    super(raw.to_s)
    @encrypted = self.encrypt(:symmetric)
  end

  # Converts an object of this instance into a database friendly value.
  def mongoize
    @encrypted
  end

  class << self

    # Get the object as it was stored in the database, and instantiate this custom class from it.
    def demongoize(object)
      return object unless valid_object?(object)
      EncryptedString.new(object.decrypt(:symmetric))
    end

    # Takes any possible object and converts it to how it would be stored in the database.
    def mongoize(object)
      case
        when object.is_a?(EncryptedString)
          object.mongoize
        when is_encrypted?(object)
          # It's already encrypted
          object
        when invalid_object?(object)
          object
        else
          EncryptedString.new(object).mongoize
      end
    end

    # Converts the object that was supplied to a criteria and converts it into a database friendly form.
    def evolve(object)
      mongoize(object)
    end

    # Can this object be encrypted?  Nil and Empty Strings cannot be encrypted and write to the database "as is"
    def valid_object?(object)
      !invalid_object?(object)
    end

    def invalid_object?(object)
      object.to_s.empty?
    end

    def is_encrypted?(object)
      object.respond_to?(:encrypted?) && object.encrypted?
    end

  end
end