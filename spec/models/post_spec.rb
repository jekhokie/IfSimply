require 'spec_helper'

describe Post do
  it { should belong_to :topic }

  it "can be instantiated" do
    Post.new.should be_an_instance_of(Post)
  end

  describe "default sort order" do
    let!(:topic)  { FactoryGirl.create :topic }
    let!(:post_3) { FactoryGirl.create :post, :topic => topic, :created_at => Time.local(2013,"jan",5,20,15,45) }
    let!(:post_1) { FactoryGirl.create :post, :topic => topic, :created_at => Time.local(2013,"jan",2,20,15,45) }
    let!(:post_2) { FactoryGirl.create :post, :topic => topic, :created_at => Time.local(2013,"jan",2,20,17,45) }

    it "returns posts by created_at in ascending order" do
      topic.posts.should == [ post_1, post_2, post_3 ]
    end
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
