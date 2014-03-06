module SequelSpec
  module Matchers
    module Association
      class HaveManyToOneMatcher < AssociationMatcher
        def initialize(attribute)
          @association_type = :many_to_one
          super
        end
      end

      def have_many_to_one(*args)
        HaveManyToOneMatcher.new(*args)
      end
    end
  end
end
