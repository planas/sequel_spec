module SequelSpec
  module Matchers
    module Validation
      class ValidatePresenceMatcher < ValidateMatcher
        def description
          desc = "validate presence of #{@attribute.inspect}"
          desc << " with option(s) #{hash_to_nice_string @options}" unless @options.empty?
          desc
        end

        def validation_type
          :validates_presence
        end
      end

      def validate_presence(attribute)
        ValidatePresenceMatcher.new(attribute)
      end

      alias :validate_presence_of :validate_presence
    end
  end
end
