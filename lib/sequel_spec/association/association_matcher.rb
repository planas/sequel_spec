module SequelSpec
  module Matchers
    module Association
      class AssociationMatcher < Base
        def description
          desc = "have a #{association_type} association #{@attribute.inspect}"
          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        def valid?(db, instance, klass, attribute, options)
          @association = klass.association_reflection(attribute) || {}

          if @association.empty?
            @suffix << "(no association #{@attribute.inspect} found)"
            false
          else
            matching = @association[:type] == association_type
            options.each do |key, value|
              assoc_key = @association[key]

              if assoc_key.is_a?(String) && assoc_key.start_with?('::')
                assoc_key = assoc_key.demodulize
              end

              if assoc_key != value
                @suffix << "expected #{key.inspect} == #{value.inspect} but found #{assoc_key.inspect} instead"
                matching = false
              end
            end

            matching
          end
        end
      end
    end
  end
end
