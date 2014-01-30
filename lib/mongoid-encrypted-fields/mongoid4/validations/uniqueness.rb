# encoding: utf-8

module Mongoid
  module Validatable

    # Monkey-patch for Mongoid's uniqueness validator to enforce that the :case_sensitive option does not work
    # for encrypted fields; they must always be case-sensitive.
    # Patch is confirmed to work on Mongoid >= 4.0.0
    class UniquenessValidator

      # Setup has been deprecated in ActiveModel 4.1
      if instance_methods(false).include?(:setup)

        def setup_with_validation(klass)
          setup_without_validation(klass)
          return if case_sensitive?
          attributes.each do |attribute|
            field_type = @klass.fields[@klass.database_field_name(attribute)].options[:type]
            raise ArgumentError, "Encrypted field :#{attribute} cannot support case insensitive uniqueness" if field_type.method_defined?(:encrypted)
          end
        end

        alias_method :setup_without_validation, :setup
        alias_method :setup, :setup_with_validation

      else

        # ActiveModel 4.1+ adds options[:class] to reference the document that included this validation
        def check_validity!
          return if case_sensitive?
          attributes.each do |attribute|
            field_type = options[:class].fields[options[:class].database_field_name(attribute)].options[:type]
            raise ArgumentError, "Encrypted field :#{attribute} cannot support case insensitive uniqueness" if field_type.method_defined?(:encrypted)
          end
        end

      end

    end
  end
end