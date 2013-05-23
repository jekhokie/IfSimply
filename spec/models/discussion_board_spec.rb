require 'spec_helper'

describe DiscussionBoard do
  it { should belong_to :club }

  it "can be instantiated" do
    DiscussionBoard.new.should be_an_instance_of(DiscussionBoard)
  end

  describe "valid?" do
    # name
    it "returns false when no name is specified" do
      FactoryGirl.build(:discussion_board, :name => "").should_not be_valid
    end

    # description
    it "returns false when no description is specified" do
      FactoryGirl.build(:discussion_board, :description => "").should_not be_valid
    end
  end

  describe "user" do
    let(:club) { FactoryGirl.create :club }

    it "returns the corresponding blog's user" do
      FactoryGirl.create(:discussion_board, :club_id => club.id).user.should == club.user
    end
  end

  describe "assign_defaults" do
    let(:club) { FactoryGirl.create :club }

    before :each do
      @discussion_board = DiscussionBoard.new
      @discussion_board.club_id = club.id
      @discussion_board.assign_defaults
      @discussion_board.save
    end

    it "assigns the correct default name" do
      @discussion_board.name.should == Settings.blogs[:default_name]
    end

    it "assigns the correct default description" do
      @discussion_board.description.should == Settings.blogs[:default_descripton]
    end
  end
end
