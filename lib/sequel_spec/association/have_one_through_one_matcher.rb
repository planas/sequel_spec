module SequelSpec
  module Matchers
    module Association
      class HaveOneThroughOneMatcher < AssociationMatcher
        def association_type
          :one_through_one
        end
      end

      def have_one_through_one(*args)
        HaveOneThroughOneMatcher.new(*args)
      end
    end
  end
end
