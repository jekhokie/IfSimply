require 'spec_helper'

describe Club do
  it { should belong_to :user }
  it { should have_many :courses }
  it { should have_many :articles }
  it { should have_one  :discussion_board }
  it { should have_one  :sales_page }
  it { should have_one  :upsell_page }

  it { should have_many(:topics).through(:discussion_board) }

  it { should have_many :subscriptions }

  it { should have_many(:lessons).through(:courses) }

  it "can be instantiated" do
    Club.new.should be_an_instance_of(Club)
  end

  describe "initialize" do
    let!(:club) { FactoryGirl.create(:user).clubs.first }

    it "assigns the default name" do
      club.name.should == Settings.clubs[:default_name]
    end

    it "assigns the default sub_heading" do
      club.sub_heading.should == Settings.clubs[:default_sub_heading]
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

    it "assigns the default free_content" do
      club.free_content.should == Settings.clubs[:default_free_content]
    end

    # discussion_board
    it "builds a default discussion_board" do
      club.discussion_board.should_not be_blank
    end

    # sales_page
    it "builds a default sales_page" do
      club.sales_page.should_not be_blank
    end

    # upsell_page
    it "builds a default upsell_page" do
      club.upsell_page.should_not be_blank
    end
  end

  describe "valid?" do
    # name
    it "returns false when no name is specified" do
      FactoryGirl.build(:club, :name => "").should_not be_valid
    end

    it "returns false when name is greater than max characters" do
      FactoryGirl.build(:club, :name => Faker::Lorem.characters(Settings.clubs[:name_max_length] + 1)).should_not be_valid
    end

    # sub_heading
    it "returns false when no sub_heading is specified" do
      FactoryGirl.build(:club, :sub_heading => "").should_not be_valid
    end

    it "returns false when sub_heading is greater than max characters" do
      FactoryGirl.build(:club, :sub_heading => Faker::Lorem.characters(Settings.clubs[:sub_heading_max_length] + 1)).should_not be_valid
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

    # free_content
    describe "for free_content" do
      it "returns false when no free_content is specified" do
        FactoryGirl.build(:club, :free_content => "").should_not be_valid
      end

      it "returns true when free_content is a string of a boolean" do
        FactoryGirl.build(:club, :free_content => true).should be_valid
      end
    end

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

  describe "courses ordering" do
    let(:club)    { FactoryGirl.create :club }
    let(:course3) { FactoryGirl.create :course, :club_id => club.id, :position => 3 }
    let(:course1) { FactoryGirl.create :course, :club_id => club.id, :position => 1 }
    let(:course2) { FactoryGirl.create :course, :club_id => club.id, :position => 2 }

    it "should order courses by position" do
      club.courses.should == [ course1, course2, course3 ]
    end
  end

  describe "articles" do
    before :each do
      @club = FactoryGirl.create :club
      FactoryGirl.create :article, :club_id => @club.id
    end

    it "should be destroyed when the club is destroyed" do
      expect { @club.destroy }.to change(Article, :count).by(-1)
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

  describe "sales_page" do
    before :each do
      @club = FactoryGirl.create :club
      FactoryGirl.create :sales_page, :club_id => @club.id
    end

    it "should be destroyed when the club is destroyed" do
      expect { @club.destroy }.to change(SalesPage, :count).by(-1)
    end
  end

  describe "upsell_page" do
    before :each do
      @club = FactoryGirl.create :club
      FactoryGirl.create :upsell_page, :club_id => @club.id
    end

    it "should be destroyed when the club is destroyed" do
      expect { @club.destroy }.to change(UpsellPage, :count).by(-1)
    end
  end

  describe "members" do
    let!(:club)         { FactoryGirl.create :club }
    let!(:subscriber)   { FactoryGirl.create :user }
    let!(:subscription) { FactoryGirl.create :subscription, :club => club, :user => subscriber }

    it "reports the list of members" do
      club.members.should include(subscriber)
    end

    describe "for pro members" do
      let!(:active_pro_subscriber)    { FactoryGirl.create :user }
      let!(:expired_pro_subscriber)   { FactoryGirl.create :user }
      let!(:active_pro_subscription)  { FactoryGirl.create :subscription, :club => club, :user => active_pro_subscriber,  :level => 'pro', :pro_status => "ACTIVE" }
      let!(:expired_pro_subscription) { FactoryGirl.create :subscription, :club => club, :user => expired_pro_subscriber, :level => 'pro', :pro_status => "INACTIVE" }

      it "includes pro members who have an active pro subscription" do
        club.members.should include(active_pro_subscriber)
      end

      it "does not include pro members whose pro subscription has expired" do
        club.members.should_not include(expired_pro_subscriber)
      end
    end
  end
end
