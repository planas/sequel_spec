module SequelSpec
  module Matchers
    module Validation
      class ValidateExactLengthMatcher < ValidateMatcher
        def description
          desc = "validate length of #{@attribute.inspect} is exactly #{@additionnal.inspect}"
          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        def additionnal_param_type
          Fixnum
        end

        def validation_type
          :validates_exact_length
        end
      end

      def validate_exact_length(*args)
        ValidateExactLengthMatcher.new(*args)
      end
    end
  end
end
