require 'spec_helper'

describe SalesPagesController do
  describe "GET 'show'" do
    let!(:club)       { FactoryGirl.create :club }
    let!(:sales_page) { club.sales_page }

    before :each do
      get 'show', :club_id => sales_page.club.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the club" do
      assigns(:club).should == sales_page.club
    end

    it "returns the sales_page" do
      assigns(:sales_page).should == sales_page
    end
  end

  describe "GET 'edit'" do
    let!(:user)       { FactoryGirl.create :user }
    let!(:sales_page) { user.clubs.first.sales_page }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    before :each do
      get 'edit', :club_id => sales_page.club.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the club" do
      assigns(:club).should == sales_page.club
    end

    it "returns the sales_page" do
      assigns(:sales_page).should == sales_page
    end
  end
end
