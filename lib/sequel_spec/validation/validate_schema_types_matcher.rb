module SequelSpec
  module Matchers
    module Validation
      class ValidateSchemaTypesMatcher < ValidateMatcher
        def description
          desc = "validate schema types of #{@attribute.inspect}"
          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        def validation_type
          :validates_schema_types
        end
      end

      def validate_schema_types(attribute)
        ValidateSchemaTypesMatcher.new(attribute)
      end

      alias :validate_schema_types_of :validate_schema_types
    end
  end
end
