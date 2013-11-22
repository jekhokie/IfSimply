require 'spec_helper'

describe UpsellPagesController do
  describe "GET 'edit'" do
    let!(:user)        { FactoryGirl.create :user }
    let!(:upsell_page) { user.clubs.first.upsell_page }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    before :each do
      get "edit", :club_id => upsell_page.club.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the club" do
      assigns(:club).should == upsell_page.club
    end

    it "returns the sales_page" do
      assigns(:upsell_page).should == upsell_page
    end

    it "renders the mercury layout" do
      response.should render_template(:layout => "layouts/mercury")
    end
  end
end
