require 'spec_helper'

describe "validate_length_range_matcher" do
  before do
    define_model :item do
      plugin :validation_helpers

      def validate
        validates_length_range 1..10, :name, :allow_nil => true
      end
    end
  end

  subject{ Item }

  describe "arguments" do
    context "with the old syntax" do
      it "should require attribute" do
        expect {
          @matcher = validate_length_range
        }.to raise_error(ArgumentError)
      end

      it "should require additionnal parameters" do
        expect {
          @matcher = validate_length_range :name
        }.to raise_error(ArgumentError)
      end

      it "should refuse invalid additionnal parameters" do
        expect {
          @matcher = validate_length_range :id, :name
        }.to raise_error(ArgumentError)
      end

      it "should accept valid additionnal parameters" do
        expect {
          @matcher = validate_length_range 1..10, :name
        }.not_to raise_error
      end
    end

    context "with the new syntax" do
      # @TODO: This two first examples are duplicated across implementations
      it "should require attribute" do
        expect {
          @matcher = validate_length_of
        }.to raise_error(ArgumentError)
      end

      it "should refuse invalid additionnal parameters" do
        expect {
          @matcher = validate_length_of(:id, :name)
        }.to raise_error(ArgumentError)
      end

      it "should require additionnal parameters" do
        expect {
          @matcher = validate_length_of(:name).matches? # it doesn't whine until #matches? is called
        }.to raise_error(ArgumentError)
      end

      it "should accept with valid additionnal parameters" do
        expect {
          @matcher = validate_length_of(:name).is_between(1..10)
        }.not_to raise_error
      end
    end
  end

  describe "messages" do
    context "with the old syntax" do
      describe "without option" do
        it "should contain a description" do
          @matcher = validate_length_range 1..10, :name
          @matcher.description.should == "validate length of :name is included in 1..10"
        end
        it "should set failure messages" do
          @matcher = validate_length_range 1..10, :name
          @matcher.matches? subject
          @matcher.failure_message.should == "expected Item to " + @matcher.description
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
        end
      end
      describe "with options" do
        it "should contain a description" do
          @matcher = validate_length_range 1..10, :name, :allow_nil => true
          @matcher.description.should == "validate length of :name is included in 1..10 with option(s) :allow_nil => true"
        end
        it "should set failure messages" do
          @matcher = validate_length_range 1..10, :price, :allow_nil => true
          @matcher.matches? subject
          @matcher.failure_message.should == "expected Item to " + @matcher.description
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
        end
        it "should explicit used options if different than expected" do
          @matcher = validate_length_range 1..10, :name, :allow_blank => true
          @matcher.matches? subject
          explanation = " but called with option(s) :allow_nil => true instead"
          @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
        end
        it "should warn if invalid options are used" do
          @matcher = validate_length_range 1..10, :name, :allow_anything => true
          @matcher.matches? subject
          explanation = " but option :allow_anything is not valid"
          @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
        end
      end
    end

    context "with the new syntax" do
      describe "without option" do
        it "should contain a description" do
          @matcher = validate_length_of(:name).is_between(1..10)
          @matcher.description.should == "validate length of :name is included in 1..10"
        end
        it "should set failure messages" do
          @matcher = validate_length_of(:name).is_between(1..10)
          @matcher.matches? subject
          @matcher.failure_message.should == "expected Item to " + @matcher.description
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
        end
      end

      <<-PENDING
      describe "with options" do
        it "should contain a description" do
          @matcher = validate_length_range 1..10, :name, :allow_nil => true
          @matcher.description.should == "validate length of :name is included in 1..10 with option(s) :allow_nil => true"
        end
        it "should set failure messages" do
          @matcher = validate_length_range 1..10, :price, :allow_nil => true
          @matcher.matches? subject
          @matcher.failure_message.should == "expected Item to " + @matcher.description
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
        end
        it "should explicit used options if different than expected" do
          @matcher = validate_length_range 1..10, :name, :allow_blank => true
          @matcher.matches? subject
          explanation = " but called with option(s) :allow_nil => true instead"
          @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
        end
        it "should warn if invalid options are used" do
          @matcher = validate_length_range 1..10, :name, :allow_anything => true
          @matcher.matches? subject
          explanation = " but option :allow_anything is not valid"
          @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
        end
      end
      PENDING
    end
  end

  describe "matchers" do
    context "with the old syntax" do
      it{ should validate_length_range(1..10, :name) }
      it{ should validate_length_range(1..10, :name, :allow_nil => true) }
      it{ should_not validate_length_range(1..10, :price) }
      it{ should_not validate_length_range(0..10, :name) }
      it{ should_not validate_length_range(1..10, :name, :allow_blank => true) }
    end

    context "with the new syntax" do
      it{ should validate_length_of(:name).is_between(1..10) }
      #it{ should validate_length_range(1..10, :name, :allow_nil => true) }
      it{ should_not validate_length_of(:price).is_between(1..10) }
      it{ should_not validate_length_of(:name).is_between(0..10) }
      #it{ should_not validate_length_range(1..10, :name, :allow_blank => true) }
    end
  end
end
