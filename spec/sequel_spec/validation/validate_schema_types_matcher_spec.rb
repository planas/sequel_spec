require 'spec_helper'

describe "validate_schema_types_matcher" do
  before :all do
    define_model :item do
      plugin :validation_helpers

      def validate
        validates_schema_types :name, :message => "Not a valid string"
      end
    end
  end

  subject{ Item }

  it "should require an attribute" do
    expect {
      subject.should validate_schema_types_of
    }.to raise_error(ArgumentError)
  end

  it "should accept with valid parameters" do
    expect {
      subject.should validate_schema_types_of(:name)
    }.not_to raise_error
  end

  it "should reject with invalid parameters" do
    expect {
      subject.should validate_schema_types_of(:origin)
    }.to raise_error
  end

  it "should accept with valid parameters and valid options" do
    expect {
      subject.should validate_schema_types_of(:name).with_message "Not a valid string"
    }.not_to raise_error
  end

  it "should reject with valid parameters but invalid options" do
    expect {
      subject.should validate_schema_types_of(:name).allowing_blank
    }.to raise_error
  end

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = validate_schema_types_of(:name)
        @matcher.description.should == 'validate schema types of :name'
      end

      it "should set failure messages" do
        @matcher = validate_schema_types_of(:name)
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end
    end

    describe "with options" do
      it "should contain a description" do
        @matcher = validate_schema_types_of(:name).with_message "Not a valid string"
        @matcher.description.should == 'validate schema types of :name with option(s) :message => "Not a valid string"'
      end

      it "should set failure messages" do
        @matcher = validate_schema_types_of(:username).with_message("Not a valid string")
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end

      it "should explicit used options if different than expected" do
        @matcher = validate_schema_types_of(:name).with_message "Not a valid hash"
        @matcher.matches? subject
        explanation = ' but called with option(s) :message => "Not a valid string" instead'
        @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
      end
    end
  end
end
