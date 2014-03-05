require 'spec_helper'

describe "validate_not_string_matcher" do
  before do
    define_model :item do
      plugin :validation_helpers

      def validate
        validates_not_string [:id, :name], :allow_nil => true
      end
    end
  end

  subject{ Item }

  describe "arguments" do
    it "should require attribute" do
      expect {
        @matcher = validate_not_string
      }.to raise_error(ArgumentError)
    end
    it "should refuse additionnal parameters" do
      expect {
        @matcher = validate_not_string :name, :id
      }.to raise_error(ArgumentError)
    end
  end

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = validate_not_string :name
        @matcher.description.should == "validate that :name is not a string"
      end

      it "should set failure messages" do
        @matcher = validate_not_string :name
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end
    end

    describe "with options" do
      it "should contain a description" do
        @matcher = validate_not_string(:name).allowing_nil
        @matcher.description.should == "validate that :name is not a string with option(s) :allow_nil => true"
      end

      it "should set failure messages" do
        @matcher = validate_not_string(:price).allowing_nil
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end

      it "should explicit used options if different than expected" do
        @matcher = validate_not_string(:name).allowing_blank
        @matcher.matches? subject
        explanation = " but called with option(s) :allow_nil => true instead"
        @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
      end
    end
  end

  describe "matchers" do
    it{ should validate_not_string(:name) }
    it{ should validate_not_string(:name).allowing_nil }
    it{ should_not validate_not_string(:price) }
    it{ should_not validate_not_string(:name).allowing_blank }
  end
end
