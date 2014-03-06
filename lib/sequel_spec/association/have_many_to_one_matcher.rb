module SequelSpec
  module Matchers
    module Association
      class HaveManyToOneMatcher < AssociationMatcher
        def association_type
          :many_to_one
        end
      end

      def have_many_to_one(*args)
        HaveManyToOneMatcher.new(*args)
      end
    end
  end
end
