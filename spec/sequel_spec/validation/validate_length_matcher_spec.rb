require 'spec_helper'

describe "validate_length_matcher" do
  before :all do
    define_model :item do
      plugin :validation_helpers

      def validate
        validates_length_range 1..10, :manufacturer, :allow_nil => true
        validates_exact_length 4,     :name,         :allow_nil => true
        validates_min_length   4,     :owner,        :allow_nil => true
        validates_max_length   4,     :origin,       :allow_nil => true
      end
    end
  end

  subject{ Item }

  it "should require an attribute" do
    expect {
      expect(subject).to validate_length_of
    }.to raise_error(ArgumentError)
  end

  it "should require additionnal parameters" do
    expect {
      expect(subject).to validate_length_of(:name)
    }.to raise_error(ArgumentError)
  end

  it "should accept with valid parameters and options" do
    expect {
      expect(subject).to validate_length_of(:name).is(4).allowing_nil
    }.not_to raise_error
  end

  it "should reject with valid parameters but invalid options" do
    expect {
      expect(subject).to validate_length_of(:name).is(4).allowing_blank
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  context "with exact length" do
    it "should accept with valid parameters" do
      expect {
        expect(subject).to validate_length_of(:name).is(4)
      }.not_to raise_error
    end

    it "should reject with invalid parameters" do
      expect {
        expect(subject).to validate_length_of(:name).is(5)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  context "with length range" do
    it "should accept with valid parameters" do
      expect {
        expect(subject).to validate_length_of(:manufacturer).is_between(1..10)
      }.not_to raise_error
    end

    it "should reject with invalid parameters" do
      expect {
        expect(subject).to validate_length_of(:manufacturer).is_between(1..20)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  context "with minimum length" do
    it "should accept with valid parameters" do
      expect {
        expect(subject).to validate_length_of(:owner).is_at_least(4)
      }.not_to raise_error
    end

    it "should reject with invalid parameters" do
      expect {
        expect(subject).to validate_length_of(:owner).is_at_least(8)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  context "with maximum length" do
    it "should accept with valid parameters" do
      expect {
        expect(subject).to validate_length_of(:origin).is_at_most(4)
      }.not_to raise_error
    end

    it "should reject with invalid parameters" do
      expect {
        expect(subject).to validate_length_of(:origin).is_at_most(8)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  describe "messages" do
    context "with exact length" do
      describe "without option" do
        it "should contain a description" do
          @matcher = validate_length_of(:name).is(4)
          expect(@matcher.description).to eq "validate that length of :name is exactly 4"
        end

        it "should set failure messages" do
          @matcher = validate_length_of(:name).is(4)
          @matcher.matches? subject
          expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
          expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
        end
      end

      describe "with options" do
        it "should contain a description" do
          @matcher = validate_length_of(:name).is(4).allowing_nil
          expect(@matcher.description).to eq "validate that length of :name is exactly 4 with option(s) :allow_nil => true"
        end

        it "should set failure messages" do
          @matcher = validate_length_of(:price).is(4).allowing_nil
          @matcher.matches? subject
          expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
          expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
        end

        it "should explicit used options if different than expected" do
          @matcher = validate_length_of(:name).is(4).allowing_blank
          @matcher.matches? subject
          explanation = " but called with option(s) :allow_nil => true instead"
          expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description + explanation
          expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description + explanation
        end
      end
    end

    context "with length range" do
      describe "without option" do
        it "should contain a description" do
          @matcher = validate_length_of(:manufacturer).is_between(1..10)
          expect(@matcher.description).to eq "validate that length of :manufacturer is included in 1..10"
        end

        it "should set failure messages" do
          @matcher = validate_length_of(:manufacturer).is_between(1..10)
          @matcher.matches? subject
          expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
          expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
        end
      end

      describe "with options" do
        it "should contain a description" do
          @matcher = validate_length_of(:manufacturer).is_between(1..10).allowing_nil
          expect(@matcher.description).to eq "validate that length of :manufacturer is included in 1..10 with option(s) :allow_nil => true"
        end

        it "should set failure messages" do
          @matcher = validate_length_of(:price).is_between(1..10).allowing_nil
          @matcher.matches? subject
          expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
          expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
        end

        it "should explicit used options if different than expected" do
          @matcher = validate_length_of(:manufacturer).is_between(1..10).allowing_blank
          @matcher.matches? subject
          explanation = " but called with option(s) :allow_nil => true instead"
          expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description + explanation
          expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description + explanation
        end
      end
    end

    context "with minimum range" do
      describe "without option" do
        it "should contain a description" do
          @matcher = validate_length_of(:owner).is_at_least(4)
          expect(@matcher.description).to eq "validate that length of :owner is greater than or equal to 4"
        end

        it "should set failure messages" do
          @matcher = validate_length_of(:owner).is_at_least(4)
          @matcher.matches? subject
          expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
          expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
        end
      end

      describe "with options" do
        it "should contain a description" do
          @matcher = validate_length_of(:owner).is_at_least(4).allowing_nil
          expect(@matcher.description).to eq "validate that length of :owner is greater than or equal to 4 with option(s) :allow_nil => true"
        end

        it "should set failure messages" do
          @matcher = validate_length_of(:price).is_at_least(4).allowing_nil
          @matcher.matches? subject
          expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
          expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
        end

        it "should explicit used options if different than expected" do
          @matcher = validate_length_of(:owner).is_at_least(4).allowing_blank
          @matcher.matches? subject
          explanation = " but called with option(s) :allow_nil => true instead"
          expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description + explanation
          expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description + explanation
        end
      end
    end

    context "with maximum range" do
      describe "without option" do
        it "should contain a description" do
          @matcher = validate_length_of(:origin).is_at_most(4)
          expect(@matcher.description).to eq "validate that length of :origin is less than or equal to 4"
        end

        it "should set failure messages" do
          @matcher = validate_length_of(:origin).is_at_most(4)
          @matcher.matches? subject
          expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
          expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
        end
      end

      describe "with options" do
        it "should contain a description" do
          @matcher = validate_length_of(:origin).is_at_most(4).allowing_nil
          expect(@matcher.description).to eq "validate that length of :origin is less than or equal to 4 with option(s) :allow_nil => true"
        end

        it "should set failure messages" do
          @matcher = validate_length_of(:price).is_at_most(4).allowing_nil
          @matcher.matches? subject
          expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description
          expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description
        end

        it "should explicit used options if different than expected" do
          @matcher = validate_length_of(:origin).is_at_most(4).allowing_blank
          @matcher.matches? subject
          explanation = " but called with option(s) :allow_nil => true instead"
          expect(@matcher.failure_message).to eq "expected Item to " + @matcher.description + explanation
          expect(@matcher.failure_message_when_negated).to eq "expected Item to not " + @matcher.description + explanation
        end
      end
    end
  end
end
