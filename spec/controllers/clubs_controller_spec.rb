require 'spec_helper'

describe ClubsController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'edit'" do
    describe "for a non signed-in user" do
      describe "for a club not belonging to user" do
        it "redirects for user sign in" do
          get 'edit', :id => FactoryGirl.create(:club).id

          response.should be_redirect
          response.should redirect_to new_user_session_path
        end
      end

      describe "for a club belonging to user" do
        it "redirects for user sign in" do
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

        it "renders the access_violation template" do
          response.should render_template('home/access_violation')
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

  describe "PUT 'update'" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    let(:club)     { user.clubs.first }
    let(:new_name) { "Test Club" }

    describe "for valid attributes" do
      before :each do
        put 'update', :id => club.id, :club => { :name => new_name }
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end

      it "assigns the new attributes" do
        club.reload
        club.name.should == new_name
      end
    end

    describe "for invalid attributes" do
      before :each do
        @old_name = club.name
        put 'update', :id => club.id, :club => { :name => "" }
      end

      it "returns http success" do
        response.response_code.should == 422
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end

      it "does not update the attributes" do
        club.reload
        club.name.should == @old_name
      end
    end
  end
end
