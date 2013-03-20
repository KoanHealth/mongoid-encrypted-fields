# encoding: utf-8
#
# Used to store an encrypted hash in Mongo
#
# Usage:
# field :address, type: Mongoid::EncryptedHash
#
# Set with an unencrypted hash
# p = Person.new()
# p.address = {street: "123 Main St", city: "Springdale", state: "MD"}
#
# Get returns the unencrypted hash
# puts p.address -> {:street=>"123 Main St", :city=>"Springdale", :state=>"MD"}
#
# Use the encrypted property to see the encrypted value
# puts p.address.encrypted -> '....'
require 'yaml'

module Mongoid
  class EncryptedHash < ::Hash
    include Mongoid::EncryptedField

    # Return value to be encrypted
    def raw_value
      to_yaml
    end

    class << self

      # converts from a plain Hash to an EncryptedHash
      def from_hash(h)
        self[h.to_hash]
      end

      # Takes an object representation (Hash or string) and converts it to an
      # EncryptedHash.
      def convert(object)
        case object
          when Hash
            from_hash(object)
          else
            from_hash(::YAML.load(object))
        end
      end

    end
  end
end
