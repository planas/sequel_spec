require 'sequel_spec/stubber'

module SequelSpec
  module Matchers
    module Validation
      class ValidateMatcher < Base
        def initialize(attribute)
          super(attribute)
          self
        end

        def valid_options
          [:allowing_blank, :allowing_missing, :allowing_nil, :with_message]
        end

        def check_valid_option(opt)
          unless valid_options.include?(opt)
            raise ArgumentError, "This matcher doesn't allow the option #{opt}"
          end
        end

        def allowing_nil
          check_valid_option :allowing_nil
          @options[:allow_nil] = true
          self
        end

        def allowing_blank
          check_valid_option :allowing_blank
          @options[:allow_blank] = true
          self
        end

        def allowing_missing
          check_valid_option :allowing_missing
          @options[:allowing_missing] = true
          self
        end

        def with_message(message)
          check_valid_option :with_message
          @options[:message] = message
          self
        end

        def additionnal_param_required?
          false
        end

        def args_to_called_attributes(args)
          [args.pop].flatten
        end

        def valid?(db, instance, klass, attribute, options)
          additionnal_param_check if self.respond_to?(:additionnal_param_check)

          # We don't want to affect the original instance
          instance = instance.dup

          # Ensure colums are read again after .dup
          instance.class.columns

          # Stub the validation_type method
          instance.extend Stubber::Integration
          stubber = instance.agnostic_stub(validation_type)

          # Run validations
          instance.valid?

          # Return directly if the expected validate method was not called
          return false unless stubber.called?

          args = stubber.called_args
          called_options = args.last.is_a?(Hash) ? args.pop : {}
          called_attributes = args_to_called_attributes(args)
          called_additionnal = args.shift if additionnal_param_required?

          if !args.empty?
            @suffix << "but called with too many params"
          elsif called_attributes.include?(attribute)
            if additionnal_param_required? && @additionnal != called_additionnal
              @suffix << "but called with #{called_additionnal} instead"
            elsif !options.empty? && called_options != options
              @suffix << "but called with option(s) #{hash_to_nice_string called_options} instead"
            else
              return true
            end
          end

          false
        end
      end
    end
  end
end
