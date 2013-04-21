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
    # for encrypted fields; they will always be case-sensitive. To achieve
    # case-insensitivity it is recommended to downcase or upcase the field
    # value in the before_validation callback.
    class UniquenessValidator
      private

      # document, attribute are added to filter method interface
      def criterion(document, attribute, value)
        attribute = document.class.aliased_fields[attribute.to_s] || attribute

        if localized?(document, attribute)
          conditions = value.inject([]) { |acc, (k,v)| acc << { "#{attribute}.#{k}" => filter(v, document, attribute) } }
          selector = { "$or" => conditions }
        else
          selector = { attribute => filter(value, document, attribute) }
        end

        if document.persisted? && !document.embedded?
          selector.merge!(_id: { "$ne" => document.id })
        end
        selector
      end

      # document, attribute are added to filter method interface
      def filter(value, document=nil, attribute=nil)
        # begin new behavior
        if document && attribute
          field_type = document.class.fields[attribute.to_s].options[:type]
          return field_type.convert(value).encrypted if field_type <= Mongoid::EncryptedField
        end
        # end new behavior
        !case_sensitive? && value ? /\A#{Regexp.escape(value.to_s)}$/i : value
      end
    end
  end
end