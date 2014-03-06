module SequelSpec
  module Matchers
    module Validation
      class ValidateTypeMatcher < ValidateMatcher
        def description
          desc = "validate that type of #{@attribute.inspect} is #{@additionnal.inspect}"
          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        def additionnal_param_required?
          true
        end

        def additionnal_param_check
          unless @additionnal
            raise ArgumentError, "You should specify the accepted types using #is"
          end
        end

        def is(value)
          unless value.is_a?(Class) || value.is_a?(Array)
            raise ArgumentError, "#with expects a Class or an array of Classes"
          end

          @additionnal = value
          self
        end

        def validation_type
          :validates_type
        end
      end

      def validate_type(attribute)
        ValidateTypeMatcher.new(attribute)
      end

      alias :validate_type_of :validate_type
    end
  end
end
