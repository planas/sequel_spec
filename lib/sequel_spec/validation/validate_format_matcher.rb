module SequelSpec
  module Matchers
    module Validation
      class ValidateFormatMatcher < ValidateMatcher
        def description
          desc = "validate format of #{@attribute.inspect} against #{@additionnal.inspect}"
          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        # temporal workaround
        def additionnal_param_required?
          true
        end

        def additionnal_param_check
          unless @additionnal
            raise ArgumentError, "You should specify the format using #with"
          end
        end

        def with(value)
          unless value.is_a?(Regexp)
            raise ArgumentError, "#with expects a Regexp"
          end

          @additionnal = value
          self
        end

        def validation_type
          :validates_format
        end
      end

      def validate_format(*args)
        ValidateFormatMatcher.new(*args)
      end

      alias :validate_format_of :validate_format
    end
  end
end
