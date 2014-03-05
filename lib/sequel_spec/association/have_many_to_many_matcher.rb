module SequelSpec
  module Matchers
    module Association
      class HaveManyToManyMatcher < AssociationMatcher
        def initialize(attribute, options = {})
          @association_type = :many_to_many
          super
        end
      end

      def have_many_to_many(*args)
        HaveManyToManyMatcher.new(*args)
      end
    end
  end
end
