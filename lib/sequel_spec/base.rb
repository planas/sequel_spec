module SequelSpec
  module Matchers
    class Base
      def initialize(attribute)
        raise ArgumentError, "Attribute not specified" unless attribute
        @attribute   = attribute
        @description = []
        @options     = {}

        self
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

      def with_options(opts)
        raise ArgumentError, "#with_options expects a hash, #{opts.class} given" unless opts.is_a? Hash

        @options.merge! opts
        self
      end

      def failure_message
        [@prefix, description, @suffix].flatten.compact.join(" ")
      end

      def failure_message_when_negated
        [@prefix, "not", description, @suffix].flatten.compact.join(" ")
      end

      def hash_to_nice_string(hash)
        hash.sort{ |a,b| a[0].to_s<=>b[0].to_s }.collect{ |param| param.collect{ |v| v.inspect }.join(" => ") }.join(", ")
      end
    end
  end
end
