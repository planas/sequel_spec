module SequelSpec
  module Matchers
    module Association
      class HaveOneToManyMatcher < AssociationMatcher
        def initialize(attribute)
          @association_type = :one_to_many
          super
        end
      end

      def have_one_to_many(*args)
        HaveOneToManyMatcher.new(*args)
      end
    end
  end
end
