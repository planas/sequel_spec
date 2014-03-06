require 'ostruct'

module SequelSpec
  class Stubber
    attr_reader :calls

    def initialize
      @calls = []
    end

    def call(args)
      @calls << OpenStruct.new(:args => args)
    end

    def called?
      @calls.size > 0
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
