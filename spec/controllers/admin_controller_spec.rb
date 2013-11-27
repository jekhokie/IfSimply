require 'spec_helper'

describe AdminController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'show'" do
    let!(:club) { user.clubs.first }

    describe "for a signed-in user" do
      describe "for the club owner" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in user

          get 'show', :id => club.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the admin show view" do
          response.should render_template("admin/show")
        end

        it "returns the club" do
          assigns(:club).should_not be_nil
        end
      end

      describe "for a subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => club }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribed_user

          get 'show', :id => club.id
        end

        it "returns http forbidden" do
          response.response_code.should == 403
        end

        it "renders the access violation view" do
          response.should render_template("home/access_violation")
        end
      end

      describe "for a non-subscriber" do
        let!(:non_subscribed_user) { FactoryGirl.create :user }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in non_subscribed_user

          get 'show', :id => club.id
        end

        it "returns http forbidden" do
          response.response_code.should == 403
        end

        it "renders the access violation view" do
          response.should render_template("home/access_violation")
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'show', :id => club.id
      end

      it "redirects to the sign-in page" do
        response.should redirect_to(new_user_session_path)
      end
    end
  end
end
