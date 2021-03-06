module SequelSpec
  module Matchers
    module Validation
      class ValidateIntegerMatcher < ValidateMatcher
        def description
          desc = "validate that #{@attribute.inspect} is a valid integer"
          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        def validation_type
          :validates_integer
        end
      end

      def validate_integer(attribute)
        ValidateIntegerMatcher.new(attribute)
      end

      alias :validate_integrity_of :validate_integer
    end
  end
end
