require 'spec_helper'

describe ClubsController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'edit'" do
    describe "for a non signed-in user" do
      describe "for a club not belonging to user" do
        it "should redirect for user sign in" do
          get 'edit', :id => FactoryGirl.create(:club).id

          response.should be_redirect
          response.should redirect_to new_user_session_path
        end
      end

      describe "for a club belonging to user" do
        it "should redirect for user sign in" do
          get 'edit', :id => user.clubs.first.id

          response.should be_redirect
          response.should redirect_to new_user_session_path
        end
      end
    end

    describe "for a signed in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user
      end

      describe "for club not belonging to user" do
        before :each do
          get 'edit', :id => FactoryGirl.create(:club).id
        end

        it "returns 403 unauthorized forbidden code" do
          response.response_code.should == 403
        end
      end

      describe "for club belonging to user" do
        before :each do
          get 'edit', :id => user.clubs.first.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "returns the club" do
          assigns(:club).should_not be_nil
        end
      end
    end
  end
end
