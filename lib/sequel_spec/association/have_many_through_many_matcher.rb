module SequelSpec
  module Matchers
    module Association
      class HaveManyThroughManyMatcher < AssociationMatcher
        def association_type
          :many_through_many
        end
      end

      def have_many_through_many(*args)
        HaveManyThroughManyMatcher.new(*args)
      end
    end
  end
end
