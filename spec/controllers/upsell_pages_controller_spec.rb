require 'spec_helper'

describe UpsellPagesController do
  describe "GET 'show'" do
    describe "for a Club owner with a verified PayPal account" do
      let!(:user)        { FactoryGirl.create :user, :verified => true }
      let!(:club)        { FactoryGirl.create :club, :user => user }
      let!(:upsell_page) { club.upsell_page }

      before :each do
        get 'show', :club_id => upsell_page.club.id
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the club" do
        assigns(:club).should == upsell_page.club
      end

      it "returns the upsell_page" do
        assigns(:upsell_page).should == upsell_page
      end
    end

    describe "for a Club owner with an unverified PayPal account" do
      let!(:user)        { FactoryGirl.create :user, :verified => false }
      let!(:club)        { FactoryGirl.create :club, :user => user }
      let!(:upsell_page) { club.upsell_page }

      before :each do
        get 'show', :club_id => upsell_page.club.id
      end

      it "redirects to the root path" do
        response.should redirect_to(root_path)
      end

      it "returns the club" do
        assigns(:club).should == upsell_page.club
      end

      it "returns the upsell_page" do
        assigns(:upsell_page).should == upsell_page
      end

      it "returns a flash error" do
        flash[:error].should_not be_blank
      end
    end
  end

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
