require 'spec_helper'

describe "validate_includes_matcher" do
  before :all do
    define_model :item do
      plugin :validation_helpers

      def validate
        validates_includes ["Joseph", "Jonathan"], :name, :allow_nil => true
      end
    end
  end

  subject{ Item }

  it "should require an attribute" do
    expect {
      subject.should ensure_inclusion_of
    }.to raise_error(ArgumentError)
  end

  it "should require additionnal parameters" do
    expect {
      subject.should ensure_inclusion_of(:name)
    }.to raise_error(ArgumentError)
  end

  it "should accept with valid parameters" do
    expect {
      subject.should ensure_inclusion_of(:name).in(["Joseph", "Jonathan"])
    }.not_to raise_error
  end

  it "should reject with invalid parameters" do
    expect {
      subject.should ensure_inclusion_of(:name).in(["Adrià", "Jonathan"])
    }.to raise_error
  end

  it "should accept with valid parameters and options" do
    expect {
      subject.should ensure_inclusion_of(:name).in(["Joseph", "Jonathan"]).allowing_nil
    }.not_to raise_error
  end

  it "should reject with valid parameters but invalid options" do
    expect {
      subject.should ensure_inclusion_of(:name).in(["Joseph", "Jonathan"]).allowing_blank
    }.to raise_error
  end

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = ensure_inclusion_of(:name).in ["Joseph", "Jonathan"]
        @matcher.description.should == 'validate that :name is included in ["Joseph", "Jonathan"]'
      end

      it "should set failure messages" do
        @matcher = ensure_inclusion_of(:name).in ["Joseph", "Jonathan"]
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end
    end
    describe "with options" do
      it "should contain a description" do
        @matcher = ensure_inclusion_of(:name).in(["Joseph", "Jonathan"]).allowing_nil
        @matcher.description.should == 'validate that :name is included in ["Joseph", "Jonathan"] with option(s) :allow_nil => true'
      end

      it "should set failure messages" do
        @matcher = ensure_inclusion_of(:price).in(["Joseph", "Jonathan"]).allowing_nil
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end

      it "should explicit used options if different than expected" do
        @matcher = ensure_inclusion_of(:name).in(["Joseph", "Jonathan"]).allowing_blank
        @matcher.matches? subject
        explanation = " but called with option(s) :allow_nil => true instead"
        @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
      end
    end
  end
end
