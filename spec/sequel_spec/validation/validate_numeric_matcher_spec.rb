require 'spec_helper'

describe "validate_numeric_matcher" do
  before :all do
    define_model :item do
      plugin :validation_helpers

      def validate
        validates_numeric [:id, :name], :allow_nil => true
      end
    end
  end

  subject{ Item }

  it "should require an attribute" do
    expect {
      expect(subject).to validate_numeric
    }.to raise_error(ArgumentError)
  end

  it "should accept with an attribute" do
    expect {
      expect(subject).to validate_numeric(:name)
    }.not_to raise_error
  end

  it "should accept with valid options" do
    expect {
      expect(subject).to validate_numeric(:name).allowing_nil
    }.not_to raise_error
  end

  it "should reject with invalid options" do
    expect {
      expect(subject).to validate_numeric(:name).allowing_blank
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = validate_numeric :name
        expect(@matcher.description).to eq "validate that :name is a valid float"
      end

      it "should set failure messages" do
        @matcher = validate_numeric :name
        @matcher.matches? subject
        expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
        expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
      end
    end
    describe "with options" do
      it "should contain a description" do
        @matcher = validate_numeric(:name).allowing_nil
        expect(@matcher.description).to eq "validate that :name is a valid float with option(s) :allow_nil => true"
      end

      it "should set failure messages" do
        @matcher = validate_numeric(:price).allowing_nil
        @matcher.matches? subject
        expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
        expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
      end

      it "should explicit used options if different than expected" do
        @matcher = validate_numeric(:name).allowing_blank
        @matcher.matches? subject
        explanation = " but called with option(s) :allow_nil => true instead"
        expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description + explanation
        expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description + explanation
      end
    end
  end
end
