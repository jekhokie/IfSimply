require 'spec_helper'

describe Topic do
  it { should belong_to :discussion_board }
  it { should have_many :posts }

  it "can be instantiated" do
    DiscussionBoard.new.should be_an_instance_of(DiscussionBoard)
  end

  describe "valid?" do
    # subject
    it "returns false when no subject is specified" do
      FactoryGirl.build(:topic, :subject => "").should_not be_valid
    end

    # description
    it "returns false when no description is specified" do
      FactoryGirl.build(:topic, :description => "").should_not be_valid
    end
  end

  describe "user" do
    let(:discussion_board) { FactoryGirl.create :discussion_board }

    it "returns the corresponding topic's user" do
      FactoryGirl.create(:topic, :discussion_board_id => discussion_board.id).user.should == discussion_board.user
    end
  end

  describe "last_updated_time" do
    let!(:updated_at) { Time.new }
    let!(:topic)      { FactoryGirl.create :topic, :updated_at => updated_at }

    it "returns the latest update date and time" do
      topic.last_updated_time.should == updated_at
    end
  end

  describe "posts" do
    before :each do
      @topic = FactoryGirl.create :topic
      FactoryGirl.create :post, :topic_id => @topic.id
    end

    it "should be destroyed when the topic is destroyed" do
      expect { @topic.destroy }.to change(Post, :count).by(-1)
    end
  end
end
