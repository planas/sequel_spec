module SequelSpec
  module Matchers
    module Association
      class HaveOneToOneMatcher < AssociationMatcher
        def association_type
          :one_to_one
        end
      end

      def have_one_to_one(*args)
        HaveOneToOneMatcher.new(*args)
      end
    end
  end
end
