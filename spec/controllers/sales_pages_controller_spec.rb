require 'spec_helper'

describe SalesPagesController do
  describe "GET 'show'" do
    let!(:sales_page) { FactoryGirl.create :sales_page }

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
end
