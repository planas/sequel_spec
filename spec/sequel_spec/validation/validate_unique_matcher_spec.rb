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
      expect(subject).to validate_unique
    }.to raise_error(ArgumentError)
  end

  it "should accept with an attribute" do
    expect {
      expect(subject).to validate_unique(:name)
    }.not_to raise_error
  end

  it "should accept with valid options" do
    expect {
      expect(subject).to validate_unique(:name).with_message "Hello"
    }.not_to raise_error
  end

  it "should reject with options with invalid values" do
    expect {
      expect(subject).to validate_unique(:name).with_message "Bye"
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "should reject with invalid options" do
    expect {
      expect(subject).to validate_unique(:name).allowing_nil
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = validate_unique :name
        expect(@matcher.description).to eq "validate uniqueness of :name"
      end

      it "should set failure messages" do
        @matcher = validate_unique :name
        @matcher.matches? subject
        expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
        expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
      end
    end

    describe "with options" do
      it "should contain a description" do
        @matcher = validate_unique(:name).with_message("Hello")
        expect(@matcher.description).to eq 'validate uniqueness of :name with option(s) :message => "Hello"'
      end

      it "should set failure messages" do
        @matcher = validate_unique(:price).with_message("Hello")
        @matcher.matches? subject
        expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
        expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
      end

      it "should explicit used options if different than expected" do
        @matcher = validate_unique(:name).with_message("Hello world")
        @matcher.matches? subject
        explanation = ' but called with option(s) :message => "Hello" instead'
        expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description + explanation
        expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description + explanation
      end
    end
  end
end
