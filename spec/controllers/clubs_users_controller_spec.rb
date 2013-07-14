require 'spec_helper'

describe ClubsUsersController do
  let(:user) { FactoryGirl.create :user }
  let(:club) { FactoryGirl.create :club }

  describe "GET 'new'" do
    describe "for a non signed-in user" do
      before :each do
        get 'new', :id => club.id, :format => 'js'
      end

      it "redirects to a new user registration path" do
        response.should redirect_to(new_user_registration_path)
      end

      it "returns the club" do
        assigns(:club).should == club
      end

      it "returns a new unsaved subscription" do
        assigns(:subscription).should be_new_record
      end

      it "returns a subscription that includes the club" do
        assigns(:subscription).club.should == club
      end

      it "assigns the subscription within the session" do
        session[:subscription].should == assigns(:subscription)
      end
    end

    describe "for a signed-in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user

        get 'new', :id => club.id, :format => 'js'
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the club" do
        assigns(:club).should == club
      end

      it "returns a new unsaved subscription" do
        assigns(:subscription).should be_new_record
      end

      it "returns a subscription that includes the club" do
        assigns(:subscription).club.should == club
      end

      it "returns a subscription that includes the user" do
        assigns(:subscription).user.should == user
      end

      it "ensures that the subscription session variable is cleared" do
        session[:subscription].should be_blank
      end
    end
  end
end
