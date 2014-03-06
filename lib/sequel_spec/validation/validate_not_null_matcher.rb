module SequelSpec
  module Matchers
    module Validation
      class ValidateNotNullMatcher < ValidateMatcher
        def description
          desc = "validate that #{@attribute.inspect} is not null"
          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        def validation_type
          :validates_not_null
        end
      end

      def validate_not_null(attribute)
        ValidateNotNullMatcher.new(attribute)
      end
    end
  end
end
