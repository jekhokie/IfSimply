require 'spec_helper'

describe Post do
  it { should belong_to :topic }

  it "can be instantiated" do
    Post.new.should be_an_instance_of(Post)
  end

  describe "valid?" do
    # content
    it "returns false when no content is specified" do
      FactoryGirl.build(:post, :content => "").should_not be_valid
    end
  end

  describe "poster" do
    let!(:user) { FactoryGirl.create :user }
    let!(:post) { FactoryGirl.create :post, :user_id => user.id }

    describe "for a current user" do
      it "returns the user" do
        post.poster.should == user
      end
    end

    describe "for a user that no longer exists" do
      before :each do
        user.destroy
      end

      it "returns 'unknown'" do
        post.poster.should == 'unknown'
      end
    end
  end
end
