require 'spec_helper'

describe ClubsUsersController do
  let(:user) { FactoryGirl.create :user }
  let(:club) { FactoryGirl.create :club }

  describe "GET 'new'" do
    describe "for a non signed-in user" do
      before :each do
        get 'new', :id => club.id
      end

      it "returns success" do
        response.should be_success
      end

      it "returns a JS response" do
        response.content_type.should == Mime::JS
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
      describe "for the club owner" do
        let!(:club_user) { FactoryGirl.create :user }
        let!(:user_club) { club_user.clubs.first }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in club_user

          get 'new', :format => :js, :id => user_club.id
        end

        it "returns success" do
          response.should be_success
        end

        it "returns a JS response" do
          response.content_type.should == Mime::JS
        end

        it "returns the club" do
          assigns(:club).should == user_club
        end

        it "returns no subscription" do
          assigns(:subscription).should be_blank
        end
      end

      describe "coming from the sales page" do
        describe "for a js response" do
          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in user

            get 'new', :format => :js, :id => club.id
          end

          it "returns http success" do
            response.should be_success
          end

          it "returns a JS response" do
            response.content_type.should == Mime::JS
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

        describe "for an html response" do
          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in user

            get 'new', :format => :html, :id => club.id
          end

          it "redirects to the club_upsell_page_path" do
            response.should redirect_to(club_upsell_page_path(club))
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

      describe "coming from a pro link for an existing basic subscriber" do
        let!(:basic_user)   { FactoryGirl.create :user }
        let!(:subscription) { FactoryGirl.create :subscription, :club => club, :user => basic_user, :level => 'basic' }

        describe "for a js response" do
          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in basic_user

            get 'new', :format => :js, :id => club.id
          end

          it "returns http success" do
            response.should be_success
          end

          it "returns a JS response" do
            response.content_type.should == Mime::JS
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

        describe "for an html response" do
          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in basic_user

            get 'new', :format => :html, :id => club.id
          end

          it "redirects to the club_upsell_page_path" do
            response.should redirect_to(club_upsell_page_path(club))
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

    describe "for a subscription to the user's own club" do
      let!(:subscribing_user) { FactoryGirl.create :user }
      let!(:user_club)        { subscribing_user.clubs.first }

      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in subscribing_user

        post 'create', :id => user_club.id, :level => 'basic'
      end

      it "redirects to the club editor view" do
        response.should redirect_to(club_editor_path(user_club))
      end

      it "returns the club" do
        assigns(:club).should == user_club
      end

      it "returns no subscription" do
        assigns(:subscription).should be_blank
      end

      it "does not add the user as a free subscriber to the club" do
        user_club.reload
        user_club.members.should_not include(subscribing_user)
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

        it "does not create an additional membership" do
          subscribing_user.memberships.count.should == 1
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
      let!(:preapproval_uuid) { "ofwihgoHOIHO(y3tg9YQ(T#Y(YT9" }

      describe "for a new subscription" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribing_user

          SecureRandom.should_receive(:uuid).and_return preapproval_uuid
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

        it "assigns the preapproval_key for the subscription" do
          assigns(:subscription).preapproval_key.should == preapproval_hash[:preapproval_key]
        end

        it "assigns the pro_status attribute as 'FAILED_PREAPPROVAL'" do
          assigns(:subscription).pro_status.should == "FAILED_PREAPPROVAL"
        end

        it "assigns the preapproval_uuid" do
          assigns(:subscription).preapproval_uuid.should == preapproval_uuid
        end

        it "does not add the subscriber as a pro member of the club" do
          club.reload
          club.members.select{ |member| member.level == 'pro' }.should_not include(subscribing_user)
        end
      end

      describe "for an existing subscription" do
        describe "that is expired" do
          let!(:preapproval_hash) { { :preapproval_key => "PA-5W790039F30657208", :preapproval_url => "http://sandbox.paypal.com" } }
          let!(:pro_user)         { FactoryGirl.create :user }
          let!(:pro_subscription) { FactoryGirl.create :subscription, :user => pro_user, :club => club, :level => 'pro', :pro_status => "INACTIVE", :was_pro => true }

          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in pro_user

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

          it "assigns the preapproval_key for the subscription" do
            assigns(:subscription).preapproval_key.should == preapproval_hash[:preapproval_key]
          end

          it "assigns the pro_status attribute as 'PRO_CHANGE'" do
            assigns(:subscription).pro_status.should == 'PRO_CHANGE'
          end

          it "does not add the subscriber as a pro member of the club" do
            club.reload
            club.members.select{ |member| member.level == 'pro' }.should_not include(pro_user)
          end

          it "does not create an additional membership" do
            pro_user.memberships.count.should == 1
          end
        end

        describe "that is active" do
          let!(:pro_user)         { FactoryGirl.create :user }
          let!(:pro_subscription) { FactoryGirl.create :subscription, :user => pro_user, :club => club, :level => 'pro', :pro_status => "ACTIVE", :was_pro => true }

          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in pro_user

            PaypalProcessor.should_not_receive(:request_preapproval)

            post 'create', :id => club.id, :level => 'pro'
          end

          it "redirects to the club show view" do
            response.should be_redirect
          end

          it "returns the club" do
            assigns(:club).should == club
          end

          it "does not create an additional membership" do
            pro_user.memberships.count.should == 1
          end
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

  describe "DELETE 'destroy'" do
    let!(:subscribing_user) { FactoryGirl.create :user }

    describe "for a basic membership subscription" do
      let!(:subscription) { FactoryGirl.create :subscription, :user => subscribing_user, :level => 'basic' }

      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in subscribing_user

        ClubsUsers.any_instance.should_receive(:destroy)

        delete 'destroy', :id => subscription.id
      end

      it "redirects to the users show view" do
        response.should redirect_to(user_editor_path(subscribing_user))
      end
    end

    describe "for a pro membership subscription" do
      let!(:subscription) { FactoryGirl.create :subscription, :user => subscribing_user, :level => 'pro', :pro_status => 'ACTIVE' }

      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in subscribing_user

        delete 'destroy', :id => subscription.id
      end

      it "redirects to the users show view" do
        response.should redirect_to(user_editor_path(subscribing_user))
      end

      it "re-assigns the pro_status to INACTIVE" do
        subscription.reload
        subscription.pro_status.should == "INACTIVE"
      end
    end

    describe "for a non signed-in user" do
      let!(:subscription) { FactoryGirl.create :subscription }

      before :each do
        delete 'destroy', :id => subscription.id
      end

      it "returns 403 unauthorized forbidden code" do
        response.response_code.should == 403
      end
    end
  end
end
