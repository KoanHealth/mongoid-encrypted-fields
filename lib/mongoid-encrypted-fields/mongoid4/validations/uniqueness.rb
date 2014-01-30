# encoding: utf-8

module Mongoid
  module Validatable

    # Monkey-patch for Mongoid's uniqueness validator to enforce that the :case_sensitive option does not work
    # for encrypted fields; they must always be case-sensitive.
    # Patch is confirmed to work on Mongoid >= 4.0.0
    class UniquenessValidator

      def check_validity!
        return if case_sensitive?
        attributes.each do |attribute|
          field_type = @klass.fields[@klass.database_field_name(attribute)].options[:type]
          raise ArgumentError, "Encrypted field :#{attribute} cannot support case insensitive uniqueness" if field_type.method_defined?(:encrypted)
        end
      end

    end
  end
end