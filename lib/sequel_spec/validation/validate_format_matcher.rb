module SequelSpec
  module Matchers
    module Validation
      class ValidateFormatMatcher < ValidateMatcher
        def description
          desc = "validate format of #{@attribute.inspect} against #{@additionnal.inspect}"
          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        def additionnal_param_type
          Regexp
        end

        def validation_type
          :validates_format
        end
      end

      def validate_format(*args)
        ValidateFormatMatcher.new(*args)
      end
    end
  end
end
