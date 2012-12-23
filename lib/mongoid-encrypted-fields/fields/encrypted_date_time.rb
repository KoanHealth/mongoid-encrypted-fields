#
# Used to store an encrypted datetime in Mongo
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
  class EncryptedDateTime < ::DateTime
    include Mongoid::EncryptedField

    class << self

      def from_datetime(d)
        parse(d.to_s)
      end

      def convert(object)
        from_datetime(object.to_datetime)
      end

    end
  end
end