module SequelSpec
  module Matchers
    module Validation
      class ValidateMatcher < Base
        def initialize(*args)
          # initialize Base
          options = args.last.is_a?(Hash) ? args.pop : {}
          super(args.pop, options)

          # check additionnal param
          if additionnal_param_required?
            if args.size > 1
              raise ArgumentError, "Too many params for matcher"
            else
              @additionnal = args.pop

              unless @additionnal.kind_of?(additionnal_param_type)
                raise ArgumentError, "Expected matcher first parameter to be #{additionnal_param_type.inspect}
                                      but received #{@additionnal.class.inspect} instead"
              end
            end
          else
            raise ArgumentError, "Too many params for matcher" unless args.empty?
          end
        end

        def allowing_nil
          @options[:allow_nil] = true
          self
        end

        def not_allowing_nil
          @options[:allow_nil] = false
          self
        end

        def allowing_blank
          @options[:allow_blank] = true
          self
        end

        def not_allowing_blank
          @options[:allow_blank] = false
          self
        end

        def allowing_missing
          @options[:allowing_missing] = true
          self
        end

        def not_allowing_missing
          @options[:allowing_missing] = false
          self
        end

        def with_message(message)
          @options[:message] = message
          self
        end

        def additionnal_param_type
          NilClass
        end

        def additionnal_param_required?
          additionnal_param_type != NilClass
        end

        def valid_options
          [:allow_blank, :allow_missing, :allow_nil, :message]
        end

        def valid?(db, instance, klass, attribute, options)
          # check options
          invalid_options = options.keys.reject { |opt| valid_options.include?(opt) }
          invalid_options.each do |opt|
            @suffix << "but option #{opt.inspect} is not valid"
          end

          return false unless invalid_options.empty?

          # check validation itself
          called_count = 0
          instance = instance.dup
          instance.class.columns # ensure colums are read again after .dup

          instance.stub(validation_type).and_return do |*args|
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
                called_count += 1
              end
            end
          end

          instance.valid?

          if called_count > 1
            @suffix << "but validation is called too many times"
            return false
          end

          called_count == 1
        end

        def args_to_called_attributes(args)
          [args.pop].flatten
        end
      end
    end
  end
end
