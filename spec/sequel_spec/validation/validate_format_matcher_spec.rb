require 'spec_helper'

describe "validate_format_matcher" do
  before :all do
    define_model :item do
      plugin :validation_helpers

      def validate
        validates_format /[abc]+/, :name, :allow_nil => true
      end
    end
  end

  subject{ Item }

  it "should require an attribute" do
    expect {
      subject.should validate_format
    }.to raise_error(ArgumentError)
  end

  it "should require additionnal parameters" do
    expect {
      subject.should validate_format(:name)
    }.to raise_error(ArgumentError)
  end

  it "should accept with valid parameters" do
    expect {
      subject.should validate_format_of(:name).with(/[abc]+/)
    }.not_to raise_error
  end

  it "should reject with invalid parameters" do
    expect {
      subject.should validate_format_of(:name).with(/[xyz]+/)
    }.to raise_error
  end

  it "should accept with valid parameters and options" do
    expect {
      subject.should validate_format_of(:name).with(/[abc]+/).allowing_nil
    }.not_to raise_error
  end

  it "should reject with valid parameters but invalid options" do
    expect {
      subject.should validate_format_of(:name).with(/[abc]+/).allowing_missing
    }.to raise_error
  end

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = validate_format_of(:name).with(/[abc]+/)
        @matcher.description.should == "validate format of :name against /[abc]+/"
      end

      it "should set failure messages" do
        @matcher = validate_format_of(:name).with(/[abc]+/)
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end
    end
    describe "with options" do
      it "should contain a description" do
        @matcher = validate_format_of(:name).with(/[abc]+/).allowing_nil
        @matcher.description.should == "validate format of :name against /[abc]+/ with option(s) :allow_nil => true"
      end

      it "should set failure messages" do
        @matcher = validate_format_of(:price).with(/[abc]+/).allowing_nil
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end

      it "should explicit used options if different than expected" do
        @matcher = validate_format_of(:name).with(/[abc]+/).allowing_blank
        @matcher.matches? subject
        explanation = " but called with option(s) :allow_nil => true instead"
        @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
      end
    end
  end
end
