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
      expect(subject).to validate_format
    }.to raise_error(ArgumentError)
  end

  it "should require additionnal parameters" do
    expect {
      expect(subject).to validate_format(:name)
    }.to raise_error(ArgumentError)
  end

  it "should accept with valid parameters" do
    expect {
      expect(subject).to validate_format_of(:name).with(/[abc]+/)
    }.not_to raise_error
  end

  it "should reject with invalid parameters" do
    expect {
      expect(subject).to validate_format_of(:name).with(/[xyz]+/)
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "should accept with valid parameters and options" do
    expect {
      expect(subject).to validate_format_of(:name).with(/[abc]+/).allowing_nil
    }.not_to raise_error
  end

  it "should reject with valid parameters but invalid options" do
    expect {
      expect(subject).to validate_format_of(:name).with(/[abc]+/).allowing_missing
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = validate_format_of(:name).with(/[abc]+/)
        expect(@matcher.description).to eq "validate format of :name against /[abc]+/"
      end

      it "should set failure messages" do
        @matcher = validate_format_of(:name).with(/[abc]+/)
        @matcher.matches? subject
        expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
        expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
      end
    end
    describe "with options" do
      it "should contain a description" do
        @matcher = validate_format_of(:name).with(/[abc]+/).allowing_nil
        expect(@matcher.description).to eq "validate format of :name against /[abc]+/ with option(s) :allow_nil => true"
      end

      it "should set failure messages" do
        @matcher = validate_format_of(:price).with(/[abc]+/).allowing_nil
        @matcher.matches? subject
        expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
        expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
      end

      it "should explicit used options if different than expected" do
        @matcher = validate_format_of(:name).with(/[abc]+/).allowing_blank
        @matcher.matches? subject
        explanation = " but called with option(s) :allow_nil => true instead"
        expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description + explanation
        expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description + explanation
      end
    end
  end
end
