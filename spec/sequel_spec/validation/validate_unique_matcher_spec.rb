require 'spec_helper'

describe "validate_unique_matcher" do
  before do
    define_model :item do
      plugin :validation_helpers

      def validate
        validates_unique [:id, :name], :name, :message => "Hello"
      end
    end
  end

  subject{ Item }

  it "should require an attribute" do
    expect {
      subject.should validate_unique
    }.to raise_error(ArgumentError)
  end

  it "should refuse not allowed options" do
    expect {
      @matcher = validate_unique(:name).allowing_nil
    }.to raise_error(ArgumentError)
  end

  it "should accept with an attribute" do
    expect {
      subject.should validate_unique(:name)
    }.not_to raise_error
  end

  it "should accept with valid options" do
    expect {
      subject.should validate_unique(:name).with_message "Hello"
    }.not_to raise_error
  end

  it "should reject with invalid options" do
    expect {
      subject.should validate_unique(:name).with_message "Bye"
    }.to raise_error
  end

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = validate_unique :name
        @matcher.description.should == "validate uniqueness of :name"
      end

      it "should set failure messages" do
        @matcher = validate_unique :name
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end
    end

    describe "with options" do
      it "should contain a description" do
        @matcher = validate_unique(:name).with_message("Hello")
        @matcher.description.should == 'validate uniqueness of :name with option(s) :message => "Hello"'
      end

      it "should set failure messages" do
        @matcher = validate_unique(:price).with_message("Hello")
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end

      it "should explicit used options if different than expected" do
        @matcher = validate_unique(:name).with_message("Hello world")
        @matcher.matches? subject
        explanation = ' but called with option(s) :message => "Hello" instead'
        @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
      end
    end
  end
end
