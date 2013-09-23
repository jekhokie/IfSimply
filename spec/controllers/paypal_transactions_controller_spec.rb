require 'spec_helper'

describe PaypalTransactionsController do
  let(:user) { FactoryGirl.create :user }
  let(:club) { FactoryGirl.create :club }

  describe "GET 'preapproval'" do
    let!(:preapproval_uuid) { "soighaoishOIEGFHOHG(#YT)(YT#()#" }
    let!(:subscription)     { FactoryGirl.create :subscription, :club => club, :user => user, :level => 'pro', :pro_status => "ACTIVE", :preapproval_uuid => preapproval_uuid }

    describe "for a non signed-in user" do
      before :each do
        get 'preapproval', :club_id => club.id, :xuuid => preapproval_uuid
      end

      it "redirects to a new user registration path" do
        response.should redirect_to(new_user_session_path)
      end

      it "does not return the club" do
        assigns(:club).should be_blank
      end
    end

    describe "for a signed-in user" do
      describe "for a user without a subscription" do
        let(:random_user) { FactoryGirl.create :user }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in random_user

          get 'preapproval', :club_id => club.id, :xuuid => preapproval_uuid
        end

        it "redirects to a new user registration path" do
          response.should redirect_to(club_sales_page_path(club))
        end

        it "returns the club" do
          assigns(:club).should == club
        end

        it "returns the sales_page" do
          assigns(:sales_page).should == club.sales_page
        end
      end

      describe "for a missing xuuid preapproval_uuid" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in user

          get 'preapproval', :club_id => club.id
        end

        it "redirects to a new user registration path" do
          response.should redirect_to(club_sales_page_path(club))
        end

        it "returns the club" do
          assigns(:club).should == club
        end

        it "returns the sales_page" do
          assigns(:sales_page).should == club.sales_page
        end
      end

      describe "for an invalid xuuid preapproval_uuid" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in user

          get 'preapproval', :club_id => club.id, :xuuid => 'bogus'
        end

        it "redirects to a new user registration path" do
          response.should redirect_to(club_sales_page_path(club))
        end

        it "returns the club" do
          assigns(:club).should == club
        end

        it "returns the sales_page" do
          assigns(:sales_page).should == club.sales_page
        end
      end

      describe "for a valid xuuid preapproval_uuid" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in user

          get 'preapproval', :club_id => club.id, :xuuid => preapproval_uuid
        end

        it "returns the club" do
          assigns(:club).should == club
        end

        it "activates the pro membership" do
          subscription.pro_status.should == "ACTIVE"
        end

        it "redirects to the club path" do
          response.should redirect_to(club_path(club))
        end
      end
    end
  end
end
