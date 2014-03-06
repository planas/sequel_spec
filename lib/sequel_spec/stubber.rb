require 'ostruct'

module SequelSpec
  class Stubber
    def when_called(&block)
      @reaction = block
    end

    def react(args)
      @reaction.call(args)
    end

    module Integration
      def agnostic_stub(method_name)
        stubber = Stubber.new

        self.class.class_eval do
          remove_method(method_name) if self.respond_to?(method_name)
          define_method(method_name) { |*args| stubber.react(args) }
        end

        stubber
      end
    end
  end
end
