require 'spec_helper'

describe Club do
  it { should belong_to :user }

  it "can be instantiated" do
    Club.new.should be_an_instance_of(Club)
  end

  describe "initialize" do
    before(:all) do
      @club = FactoryGirl.create(:user).clubs.first
    end

    it "assigns the default name" do
      @club.name.should == Settings.clubs[:default_name]
    end

    it "assigns the default description" do
      @club.description.should == Settings.clubs[:default_description]
    end

    it "assigns the default logo" do
      @club.logo.should == Settings.clubs[:default_logo]
    end

    it "assigns the default price_cents" do
      @club.price_cents.should == Settings.clubs[:default_price_cents]
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

    # user association
    it "returns false when missing a user_id" do
      FactoryGirl.build(:club, :user_id => nil).should_not be_valid
    end
  end
end
