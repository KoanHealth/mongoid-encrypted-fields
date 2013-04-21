# encoding: utf-8

module Mongoid
  module Validations # renamed to module Validatable in Mongoid 4.0

    # Monkey-patch for Mongoid's uniqueness validator to encrypt
    # uniqueness test values before querying the database
    #
    # Patch is confirmed to work on Mongoid >= 3.0.0
    # Should work in Mongoid >= 4.0.0 by renaming module Validations to Validatable
    #
    # A known limitation is that the :case_sensitive option does not work
    # for encrypted fields; they are always case-sensitive. To achieve
    # case-insensitivity it is recommended to downcase or upcase the field
    # value in the before_validation callback.
    class UniquenessValidator
      private

      def to_validate(document, attribute, value)
        metadata = document.relations[attribute.to_s]
        if metadata && metadata.stores_foreign_key?
          [ metadata.foreign_key, value.id ]
        else
          # begin new behavior
          aliased_attr = document.class.aliased_fields[attribute.to_s] || attribute.to_s
          klass = document.class.fields[aliased_attr].options[:type]
          if klass <= Mongoid::EncryptedField
            [ attribute, klass.convert(value).encrypted ]
          # end new behavior
          else
            [ attribute, value ]
          end
        end
      end
    end
  end
end