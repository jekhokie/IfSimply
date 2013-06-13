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
      get 'edit', :id => sales_page.id
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

  describe "PUT 'update'" do
    let!(:user)        { FactoryGirl.create :user }
    let!(:sales_page)  { user.clubs.first.sales_page }
    let!(:new_heading) { "Test Heading" }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    describe "for valid attributes" do
      before :each do
        put 'update', :id => sales_page.id, :sales_page => { :heading => new_heading }
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end

      it "returns the sales_page" do
        assigns(:sales_page).should == sales_page
      end

      it "assigns the new attributes" do
        sales_page.reload
        sales_page.heading.should == new_heading
      end
    end

    describe "for invalid attributes" do
      before :each do
        @old_heading = sales_page.heading
        put 'update', :id => sales_page.id, :sales_page => { :heading => "" }
      end

      it "returns http unprocessable" do
        response.response_code.should == 422
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end

      it "returns the sales_page" do
        assigns(:sales_page).should == sales_page
      end

      it "does not update the attributes" do
        sales_page.reload
        sales_page.heading.should == @old_heading
      end
    end
  end
end
