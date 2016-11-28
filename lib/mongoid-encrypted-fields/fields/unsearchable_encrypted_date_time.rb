#
# Used to store an encrypted datetime in Mongo, using a unique salt, when it is not necessary to find a record by its encrypted value
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
  class UnsearchableEncryptedDateTime < Mongoid::EncryptedDateTime
    include Mongoid::UnsearchableEncryptedField
  end
end