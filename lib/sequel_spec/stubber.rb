module SequelSpec
  class Stubber
    attr_reader :called, :called_args

    def initialize
      @called = false
      @called_args = []
    end

    def call(args)
      @called = true
      @called_args = args
    end

    def called?
      @called
    end

    module Integration
      def agnostic_stub(method_name)
        stubber = Stubber.new

        self.class.class_eval do
          remove_method(method_name) if self.respond_to?(method_name)
          define_method(method_name) { |*args| stubber.call(args) }
        end

        stubber
      end
    end
  end
end
