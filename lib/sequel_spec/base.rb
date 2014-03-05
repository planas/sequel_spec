module SequelSpec
  module Matchers
    class Base
      def initialize(attribute, options = {})
        raise ArgumentError, "Attribute not specified" unless attribute
        @attribute   = attribute
        @description = []
        @options     = options
      end

      def matches?(subject)
        @suffix = []

        if subject.is_a?(Sequel::Model)
          @prefix = "expected #{subject.inspect} to"
          valid?(subject.db, subject, subject.class, @attribute, @options)
        else
          @prefix = "expected #{subject.table_name.to_s.classify} to"
          valid?(subject.db, subject.new, subject, @attribute, @options)
        end
      end

      def failure_message
        [@prefix, description, @suffix].flatten.compact.join(" ")
      end

      def negative_failure_message
        [@prefix, "not", description, @suffix].flatten.compact.join(" ")
      end

      def hash_to_nice_string(hash)
        hash.sort{ |a,b| a[0].to_s<=>b[0].to_s }.collect{ |param| param.collect{ |v| v.inspect }.join(" => ") }.join(", ")
      end
    end
  end
end
