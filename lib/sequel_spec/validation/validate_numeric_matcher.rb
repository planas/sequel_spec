module SequelSpec
  module Matchers
    module Validation
      class ValidateNumericMatcher < ValidateMatcher
        def description
          desc = "validate that #{@attribute.inspect} is a valid float"
          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        def validation_type
          :validates_numeric
        end
      end

      def validate_numeric(*args)
        ValidateNumericMatcher.new(*args)
      end

      alias :validate_numericality_of :validate_numeric
    end
  end
end
