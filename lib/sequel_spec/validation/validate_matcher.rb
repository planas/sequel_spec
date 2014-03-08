module SequelSpec
  module Matchers
    module Validation
      class ValidateMatcher < Base
        def valid?(db, instance, klass, attribute, options)
          additionnal_param_check if self.respond_to?(:additionnal_param_check)

          instance = instance.dup
          instance.class.columns

          called = false

          proxy = Proc.new do |args|
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
                called = true
              end
            end
          end

          instance.singleton_class.send(:define_method, validation_type,
            Proc.new { |*args| proxy.call(args) }
          )

          # Run validations
          instance.valid?

          called
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
