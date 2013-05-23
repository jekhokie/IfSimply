require 'spec_helper'

describe Club do
  it { should belong_to :user }
  it { should have_many :courses }
  it { should have_many :blogs }
  it { should have_one  :discussion_board }

  it { should have_attached_file :logo }

  it "can be instantiated" do
    Club.new.should be_an_instance_of(Club)
  end

  describe "initialize" do
    let!(:club) { FactoryGirl.create(:user).clubs.first }

    it "assigns the default name" do
      club.name.should == Settings.clubs[:default_name]
    end

    it "assigns the default description" do
      club.description.should == Settings.clubs[:default_description]
    end

    it "assigns the default logo" do
      club.logo.to_s.should == Settings.clubs[:default_logo]
    end

    it "assigns the default price_cents" do
      club.price_cents.should == Settings.clubs[:default_price_cents]
    end

    # discussion_board
    it "builds a default discussion_board" do
      club.discussion_board.should_not be_blank
    end
  end

  describe "valid?" do
    # name
    it "returns false when no name is specified" do
      FactoryGirl.build(:club, :name => "").should_not be_valid
    end

    # description
    it "returns false when no description is specified" do
      FactoryGirl.build(:club, :description => "").should_not be_valid
    end

    # price_cents
    it "returns false when no price is specified" do
      FactoryGirl.build(:club, :price_cents => "").should_not be_valid
    end

    it "returns true when having a price of at least $10" do
      FactoryGirl.build(:club, :price_cents => "1000").should be_valid
    end

    it "returns false when having a price of less than $10" do
      FactoryGirl.build(:club, :price_cents => "1").should_not be_valid
    end

    # logo
    it { should validate_attachment_content_type(:logo)
           .allowing('image/jpeg', 'image/png', 'image/gif')
           .rejecting('text/plain') }

    # user association
    it "returns false when missing a user_id" do
      FactoryGirl.build(:club, :user_id => nil).should_not be_valid
    end
  end

  describe "courses" do
    before :each do
      @club = FactoryGirl.create :club
      FactoryGirl.create :course, :club_id => @club.id
    end

    it "should be destroyed when the club is destroyed" do
      expect { @club.destroy }.to change(Course, :count).by(-1)
    end
  end

  describe "blogs" do
    before :each do
      @club = FactoryGirl.create :club
      FactoryGirl.create :blog, :club_id => @club.id
    end

    it "should be destroyed when the club is destroyed" do
      expect { @club.destroy }.to change(Blog, :count).by(-1)
    end
  end

  describe "discussion_board" do
    before :each do
      @club = FactoryGirl.create :club
      FactoryGirl.create :discussion_board, :club_id => @club.id
    end

    it "should be destroyed when the club is destroyed" do
      expect { @club.destroy }.to change(DiscussionBoard, :count).by(-1)
    end
  end
end
