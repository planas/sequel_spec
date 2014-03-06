module SequelSpec
  module Matchers
    module Validation
      class ValidateLengthMatcher < ValidateMatcher
        attr_reader :validation_type

        def description
          desc = "validate length of #{@attribute.inspect} "
          desc << case validation_type
          when :validates_exact_length then "is exactly"
          when :validates_min_length   then "is greater than or equal to"
          when :validates_max_length   then "is less than or equal to"
          when :validates_length_range then "is included in"
          end << " #{@additionnal.inspect}"

          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        def additionnal_param_required?
          true
        end

        def additionnal_param_check
          unless validation_type && @additionnal
            raise ArgumentError, "You should specify the type of validation using #is, #is_at_least, #is_at_most or #is_between"
          end
        end

        def is(value)
          unless value.is_a?(Fixnum)
            raise ArgumentError, "#is expects a Fixnum, #{value.class} given"
          end

          @additionnal = value
          @validation_type = :validates_exact_length
          self
        end

        alias :is_equal_to :is

        def is_at_least(value)
          unless value.is_a?(Fixnum)
            raise ArgumentError, "#is_at_least expects a Fixnum, #{value.class} given"
          end

          @additionnal = value
          @validation_type = :validates_min_length
          self
        end

        def is_at_most(value)
          unless value.is_a?(Fixnum)
            raise ArgumentError, "#is_at_most expects a Fixnum, #{value.class} given"
          end

          @additionnal = value
          @validation_type = :validates_max_length
          self
        end

        def is_between(value)
          unless value.is_a?(Range)
            raise ArgumentError, "#is_between expects a Range, #{value.class} given"
          end

          @additionnal = value
          @validation_type = :validates_length_range
          self
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
