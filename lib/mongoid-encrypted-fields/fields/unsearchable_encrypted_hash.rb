# encoding: utf-8
#
# Used to store an encrypted hash in Mongo, using a unique salt, when it is not necessary to find a record by its encrypted value
#
# Usage:
# field :address, type: Mongoid::EncryptedHash
#
# Set with an unencrypted hash
# p = Person.new()
# p.address = {street: "123 Main St", city: "Springdale", state: "MD"}
#
# Get returns the unencrypted hash
# puts p.address -> {'street'=>"123 Main St", 'city'=>"Springdale", 'state'=>"MD"}
#
# Note that symbols used as keys are converted to strings (just like using a Hash with Mongo)
#
# Use the encrypted property to see the encrypted value
# puts p.address.encrypted -> '....'
require 'yaml'

module Mongoid
  class UnsearchableEncryptedHash < Mongoid::EncryptedHash
    include Mongoid::UnsearchableEncryptedField
  end
end
