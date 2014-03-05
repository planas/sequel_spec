module SequelSpec
  module Matchers
    module Validation
      class ValidateLengthMatcher
        def initialize(attribute)
          unless attribute
            raise ArgumentError, "You should specify an attribute"
          end

          @attribute = attribute
        end

        def matches?
          raise ArgumentError, "You should specify the type of validation using #is, #is_at_least, #is_at_most or #is_between"
        end

        def is(value)
          ValidateExactLengthMatcher.new(value, @attribute)
        end

        alias :is_equal_to :is

        def is_at_least(value)
          ValidateMinLengthMatcher.new(value, @attribute)
        end

        def is_at_most(value)
          ValidateMaxLengthMatcher.new(value, @attribute)
        end

        def is_between(value)
          ValidateLengthRangeMatcher.new(value, @attribute)
        end
      end

      def validate_length(attribute)
        ValidateLengthMatcher.new(attribute)
      end

      alias :validate_length_of :validate_length
      alias :ensure_length_of :validate_length
    end
  end
end
