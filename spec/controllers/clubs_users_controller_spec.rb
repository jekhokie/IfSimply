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
      describe "coming from the sales page" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in user

          get 'new', :id => club.id
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

      describe "coming from a pro link for an existing basic subscriber" do
        let!(:basic_user)   { FactoryGirl.create :user }
        let!(:subscription) { FactoryGirl.create :subscription, :club => club, :user => basic_user, :level => 'basic' }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in basic_user

          get 'new', :id => club.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "returns the club" do
          assigns(:club).should == club
        end

        it "returns an existing subscription" do
          assigns(:subscription).should_not be_new_record
        end

        it "returns the user's subscription" do
          assigns(:subscription).user.should == basic_user
          assigns(:subscription).club.should == club
        end

        it "ensures that the subscription session variable is cleared" do
          session[:subscription].should be_blank
        end
      end
    end
  end

  describe "POST 'create'" do
    describe "for an invalid membership level" do
      let!(:subscribing_user) { FactoryGirl.create :user }

      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in subscribing_user

        post 'create', :id => club.id, :level => 'bogus'
      end

      it "assigns flash[:error]" do
        flash[:error].should_not be_blank
      end

      it "renders 'new'" do
        response.should render_template("clubs_users/new")
      end
    end

    describe "for a basic membership subscription" do
      let!(:subscribing_user) { FactoryGirl.create :user }

      describe "for a new subscription" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribing_user

          post 'create', :id => club.id, :level => 'basic'
        end

        it "redirects to the club show view" do
          response.should redirect_to(club_path(club))
        end

        it "returns the club" do
          assigns(:club).should == club
        end

        it "returns the subscription" do
          assigns(:subscription).should_not be_blank
        end

        it "adds the user as a free subscriber to the club" do
          club.reload
          club.members.should include(subscribing_user)
        end
      end

      describe "for an existing subscription" do
        let!(:subscribing_user)      { FactoryGirl.create :user }
        let!(:existing_subscription) { FactoryGirl.create :subscription, :user => subscribing_user, :club => club, :level => 'basic' }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribing_user

          post 'create', :id => club.id, :level => 'basic'
        end

        it "redirects to the club show view" do
          response.should redirect_to(club_path(club))
        end

        it "returns the club" do
          assigns(:club).should == club
        end
      end

      describe "for a non signed-in user" do
        before :each do
          post 'create', :id => club.id, :level => 'basic'
        end

        it "redirects to the sales page" do
          response.should redirect_to(club_sales_page_path(club))
        end

        it "returns the club" do
          assigns(:club).should == club
        end

        it "returns the sales_page" do
          assigns(:sales_page).should == club.sales_page
        end
      end
    end

    describe "for a pro membership subscription" do
      let!(:subscribing_user) { FactoryGirl.create :user }
      let!(:preapproval_hash) { { :preapproval_key => "PA-5W790039F30657208", :preapproval_url => "http://sandbox.paypal.com" } }

      describe "for a new subscription" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribing_user

          PaypalProcessor.should_receive(:request_preapproval).and_return preapproval_hash

          post 'create', :id => club.id, :level => 'pro'
        end

        it "returns a redirect" do
          response.should be_redirect
        end

        it "returns the club" do
          assigns(:club).should == club
        end

        it "returns the subscription" do
          assigns(:subscription).should_not be_blank
        end

        it "assigns the preapproval for the subscription" do
          assigns(:subscription).preapproval_key.should == preapproval_hash[:preapproval_key]
        end

        it "does not add the subscriber as a member of the club" do
          club.reload
          club.members.should_not include(subscribing_user)
        end
      end

      describe "for an existing subscription" do
        let!(:subscribing_user)      { FactoryGirl.create :user }
        let!(:existing_subscription) { FactoryGirl.create :subscription, :user => subscribing_user, :club => club, :level => :pro }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribing_user

          PaypalProcessor.should_not_receive(:request_preapproval)

          post 'create', :id => club.id, :level => 'pro'
        end

        it "redirects to the club show view" do
          response.should be_redirect
        end

        it "returns the club" do
          assigns(:club).should == club
        end
      end

      describe "for a blank url returned from the paypal request" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribing_user

          PaypalProcessor.should_receive(:request_preapproval).and_return {}

          post 'create', :id => club.id, :level => 'pro'
        end

        it "renders new" do
          response.should render_template("clubs_users/new")
        end

        it "returns an error flash" do
          flash[:error].should_not be_blank
        end

        it "returns the club" do
          assigns(:club).should == club
        end
      end

      describe "for a non signed-in user" do
        before :each do
          post 'create', :id => club.id, :level => 'pro'
        end

        it "redirects to the sales page" do
          response.should redirect_to(club_sales_page_path(club))
        end

        it "returns the club" do
          assigns(:club).should == club
        end

        it "returns the sales_page" do
          assigns(:sales_page).should == club.sales_page
        end
      end
    end
  end
end
