require 'spec_helper'

describe "validate_exact_length_matcher" do
  before do
    define_model :item do
      plugin :validation_helpers

      def validate
        validates_exact_length 4, :name, :allow_nil => true
      end
    end
  end

  subject{ Item }

  describe "arguments" do
    context "with the old syntax" do
      it "should require attribute" do
        expect {
          @matcher = validate_exact_length
        }.to raise_error(ArgumentError)
      end

      it "should require additionnal parameters" do
        expect {
          @matcher = validate_exact_length :name
        }.to raise_error(ArgumentError)
      end

      it "should refuse invalid additionnal parameters" do
        expect {
          @matcher = validate_exact_length :id, :name
        }.to raise_error(ArgumentError)
      end

      it "should accept valid additionnal parameters" do
        expect {
          @matcher = validate_exact_length 4, :name
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
          @matcher = validate_length_of(:name).is(4)
        }.not_to raise_error
      end
    end
  end

  describe "messages" do
    context "with the old syntax" do
      describe "without option" do
        it "should contain a description" do
          @matcher = validate_exact_length 4, :name
          @matcher.description.should == "validate length of :name is exactly 4"
        end

        it "should set failure messages" do
          @matcher = validate_exact_length 4, :name
          @matcher.matches? subject
          @matcher.failure_message.should == "expected Item to " + @matcher.description
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
        end
      end
      describe "with options" do
        it "should contain a description" do
          @matcher = validate_exact_length 4, :name, :allow_nil => true
          @matcher.description.should == "validate length of :name is exactly 4 with option(s) :allow_nil => true"
        end

        it "should set failure messages" do
          @matcher = validate_exact_length 4, :price, :allow_nil => true
          @matcher.matches? subject
          @matcher.failure_message.should == "expected Item to " + @matcher.description
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
        end

        it "should explicit used options if different than expected" do
          @matcher = validate_exact_length 4, :name, :allow_blank => true
          @matcher.matches? subject
          explanation = " but called with option(s) :allow_nil => true instead"
          @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
        end

        it "should warn if invalid options are used" do
          @matcher = validate_exact_length 4, :name, :allow_anything => true
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
          @matcher = validate_length_of(:name).is(4)
          @matcher.description.should == "validate length of :name is exactly 4"
        end

        it "should set failure messages" do
          @matcher = validate_length_of(:name).is(4)
          @matcher.matches? subject
          @matcher.failure_message.should == "expected Item to " + @matcher.description
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
        end
      end

      <<-TODO
      describe "with options" do
        it "should contain a description" do
          @matcher = validate_exact_length 4, :name, :allow_nil => true
          @matcher.description.should == "validate length of :name is exactly 4 with option(s) :allow_nil => true"
        end

        it "should set failure messages" do
          @matcher = validate_exact_length 4, :price, :allow_nil => true
          @matcher.matches? subject
          @matcher.failure_message.should == "expected Item to " + @matcher.description
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
        end

        it "should explicit used options if different than expected" do
          @matcher = validate_exact_length 4, :name, :allow_blank => true
          @matcher.matches? subject
          explanation = " but called with option(s) :allow_nil => true instead"
          @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
        end

        it "should warn if invalid options are used" do
          @matcher = validate_exact_length 4, :name, :allow_anything => true
          @matcher.matches? subject
          explanation = " but option :allow_anything is not valid"
          @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
          @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
        end
      end
      TODO
    end
  end

  describe "matchers" do
    context "with the old syntax" do
      it{ should validate_exact_length(4, :name) }
      it{ should validate_exact_length(4, :name, :allow_nil => true) }
      it{ should_not validate_exact_length(4, :price) }
      it{ should_not validate_exact_length(3, :name) }
      it{ should_not validate_exact_length(4, :name, :allow_blank => true) }
    end

    context "with the new syntax" do
      it{ should validate_length_of(:name).is(4) }
      #it{ should validate_exact_length(4, :name, :allow_nil => true) }
      it{ should_not validate_length_of(:price).is(4) }
      it{ should_not validate_length_of(:name).is(3) }
      #it{ should_not validate_exact_length(4, :name, :allow_blank => true) }
    end
  end
end
