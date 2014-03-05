module SequelSpec
  module Matchers
    module Validation
      class ValidateLengthRangeMatcher < ValidateMatcher
        def description
          desc = "validate length of #{@attribute.inspect} is included in #{@additionnal.inspect}"
          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        def additionnal_param_type
          Enumerable
        end

        def validation_type
          :validates_length_range
        end
      end

      def validate_length_range(*args)
        ValidateLengthRangeMatcher.new(*args)
      end
    end
  end
end
