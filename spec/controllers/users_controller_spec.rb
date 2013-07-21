require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'edit'" do
    describe "for a signed-in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user
      end

      describe "accessing their own account" do
        before :each do
          get 'edit', :id => user.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the users edit view" do
          response.should render_template("users/edit")
        end

        it "assigns user" do
          assigns(:user).should == user
        end
      end

      describe "accessing another user's account" do
        let!(:other_user) { FactoryGirl.create :user }

        before :each do
          get 'edit', :id => other_user.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the users edit view" do
          response.should render_template("users/edit")
        end

        it "assigns user as their own account" do
          assigns(:user).should == user
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'edit', :id => user.id
      end

      it "redirects to the sign-in page" do
        response.should redirect_to(new_user_session_path)
      end
    end
  end
end
