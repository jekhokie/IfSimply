require 'spec_helper'

describe ClubsController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'show'" do
    let(:club) { FactoryGirl.create :club }

    describe "for a signed-in user" do
      describe "for a subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => club }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribed_user

          get 'show', :id => club.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the club show view" do
          response.should render_template("clubs/show")
        end

        it "returns the club" do
          assigns(:club).should_not be_nil
        end
      end

      describe "for a non-subscriber" do
        let!(:non_subscribed_user) { FactoryGirl.create :user }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in non_subscribed_user

          get 'show', :id => club.id
        end

        it "redirects to the sales page" do
          response.should redirect_to(club_sales_page_path(club))
        end

        it "returns the club" do
          assigns(:club).should_not be_nil
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'show', :id => club.id
      end

      it "redirects to the sales page" do
        response.should redirect_to(club_sales_page_path(club))
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end
    end
  end

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
    let(:club)     { user.clubs.first }
    let(:new_name) { "Test Club" }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

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

      it "returns http unprocessable" do
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

  describe "GET 'change_logo'" do
    let(:club) { user.clubs.first }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user

      put 'change_logo', :id => club.id, :format => :js
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the club" do
      assigns(:club).should == club
    end
  end

  describe "PUT 'upload_logo'" do
    let(:club)         { user.clubs.first }
    let(:valid_logo)   { fixture_file_upload('/soccer_ball.jpg', 'image/jpeg') }
    let(:invalid_logo) { fixture_file_upload('/soccer_ball.txt', 'text/plain') }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    describe "for a valid image format" do
      before :each do
        put 'upload_logo', :id => club.id, :club => { :logo => valid_logo }, :format => :js
      end

      it "returns http success" do
        response.should be_success
      end

      it "renders the upload_logo template" do
        response.should render_template('clubs/upload_logo')
      end

      it "returns the club" do
        assigns(:club).should == club
      end

      it "assigns the club logo" do
        File.basename(assigns(:club).logo.to_s.sub(/\?.*/, '')).should == valid_logo.original_filename
      end
    end

    describe "for an invalid image format" do
      before :each do
        put 'upload_logo', :id => club.id, :club => { :logo => invalid_logo }, :format => :js
      end

      it "returns http success" do
        response.should be_success
      end

      it "renders change_logo" do
        response.should render_template("clubs/change_logo")
      end

      it "returns the club" do
        assigns(:club).should == club
      end

      it "does not assign the club logo" do
        File.basename(assigns(:club).logo.to_s.sub(/\?.*/, '')).should_not == valid_logo.original_filename
      end
    end

    describe "for a non-specified logo value" do
      before :each do
        put 'upload_logo', :id => club.id, :format => :js
      end

      it "returns http success" do
        response.should be_success
      end

      it "renders change_logo" do
        response.should render_template("clubs/change_logo")
      end

      it "returns the course" do
        assigns(:club).should == club
      end

      it "does not assign the course logo" do
        File.basename(assigns(:club).logo.to_s.sub(/\?.*/, '')).should_not == valid_logo.original_filename
      end
    end
  end
end
