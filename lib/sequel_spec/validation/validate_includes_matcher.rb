module SequelSpec
  module Matchers
    module Validation
      class ValidateIncludesMatcher < ValidateMatcher
        def description
          desc = "validate that #{@attribute.inspect} is included in #{@additionnal.inspect}"
          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        # temp workaround
        def additionnal_param_required?
          true
        end

        def additionnal_param_check
          unless @additionnal
            raise ArgumentError, "You should specify inclusion using #in"
          end
        end

        def in(value)
          unless value.is_a?(Enumerable)
            raise ArgumentError, "#in expects a #{Enumerable}"
          end

          @additionnal = value
          self
        end

        def validation_type
          :validates_includes
        end
      end

      def validate_includes(*args)
        ValidateIncludesMatcher.new(*args)
      end

      alias :ensure_inclusion_of :validate_includes
    end
  end
end
