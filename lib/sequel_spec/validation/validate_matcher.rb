require 'sequel_spec/stubber'

module SequelSpec
  module Matchers
    module Validation
      class ValidateMatcher < Base
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

        def allowing_nil
          with_options :allow_nil => true
        end

        def allowing_blank
          with_options :allow_blank => true
        end

        def allowing_missing
          with_options :allow_missing => true
        end

        def with_message(message)
          with_options :message => message
        end

        def additionnal_param_required?
          false
        end

        def args_to_called_attributes(args)
          [args.pop].flatten
        end
      end
    end
  end
end
