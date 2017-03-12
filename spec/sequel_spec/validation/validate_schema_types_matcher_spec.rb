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
      expect(subject).to validate_schema_types_of
    }.to raise_error(ArgumentError)
  end

  it "should accept with valid parameters" do
    expect {
      expect(subject).to validate_schema_types_of(:name)
    }.not_to raise_error
  end

  it "should reject with invalid parameters" do
    expect {
      expect(subject).to validate_schema_types_of(:origin)
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "should accept with valid parameters and valid options" do
    expect {
      expect(subject).to validate_schema_types_of(:name).with_message "Not a valid string"
    }.not_to raise_error
  end

  it "should reject with valid parameters but invalid options" do
    expect {
      expect(subject).to validate_schema_types_of(:name).allowing_blank
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = validate_schema_types_of(:name)
        expect(@matcher.description).to eq 'validate schema types of :name'
      end

      it "should set failure messages" do
        @matcher = validate_schema_types_of(:name)
        @matcher.matches? subject
        expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
        expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
      end
    end

    describe "with options" do
      it "should contain a description" do
        @matcher = validate_schema_types_of(:name).with_message "Not a valid string"
        expect(@matcher.description).to eq 'validate schema types of :name with option(s) :message => "Not a valid string"'
      end

      it "should set failure messages" do
        @matcher = validate_schema_types_of(:username).with_message("Not a valid string")
        @matcher.matches? subject
        expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
        expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
      end

      it "should explicit used options if different than expected" do
        @matcher = validate_schema_types_of(:name).with_message "Not a valid hash"
        @matcher.matches? subject
        explanation = ' but called with option(s) :message => "Not a valid string" instead'
        expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description + explanation
        expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description + explanation
      end
    end
  end
end
