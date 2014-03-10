require 'spec_helper'

describe "have_many_through_many_matcher" do
  before :all do
    define_model :comment
    define_model :comments_items
    define_model :item do
      plugin :many_through_many
      many_through_many :comments, [
        [:comments_items, :item_id, :comment_id],
        [:comments, :id, :id]
      ], join_table: :comments_items
    end
  end

  subject{ Item }

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = have_many_through_many :comments
        @matcher.description.should == "have a many_through_many association :comments"
      end

      it "should set failure messages" do
        @matcher = have_many_through_many :comments
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end
    end

    describe "with options" do
      it "should contain a description" do
        @matcher = have_many_through_many(:comments).with_options :join_table => :comments_items
        @matcher.description.should == 'have a many_through_many association :comments with option(s) :join_table => :comments_items'
      end

      it "should set failure messages" do
        @matcher = have_many_through_many(:comments).with_options :class_name => "Comment"
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end

      it "should explicit used options if different than expected" do
        @matcher = have_many_through_many(:comments).with_options :join_table => :whatever
        @matcher.matches? subject
        explanation = ' expected :join_table == :whatever but found :comments_items instead'
        @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
      end
    end
  end

  describe "matchers" do
    it{ should have_many_through_many(:comments) }
    it{ should have_many_through_many(:comments).with_options :join_table => :comments_items }
    it{ should_not have_many_through_many(:prices) }
    it{ should_not have_many_through_many(:comments).with_options :class_name => "Price" }
    it{ should_not have_many_through_many(:comments).with_options :join_table => :items_comments }
  end
end
