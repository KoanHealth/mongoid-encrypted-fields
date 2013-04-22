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
    # for encrypted fields; they must always be case-sensitive.
    class UniquenessValidator

      def setup_with_validation(klass)
        setup_without_validation(klass)
        return if case_sensitive?
        attributes.each do |attribute|
          field_type = @klass.fields[attribute.to_s].options[:type]
          raise ArgumentError, "Encrypted field :#{attribute} cannot support case insensitive uniqueness" if field_type.method_defined?(:encrypted)
        end
      end

      alias_method :setup_without_validation, :setup
      alias_method :setup, :setup_with_validation

    end
  end
end