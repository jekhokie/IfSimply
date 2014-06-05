require 'spec_helper'

describe ClubsController do
  let(:user) { FactoryGirl.create :user }

  before :each do
    FakeWeb.clean_registry
    FakeWeb.register_uri(:head, "http://vimeo.com/22977143", :body => "", :status => [ "200", "OK" ])
  end

  describe "GET 'show'" do
    let(:club) { user.clubs.first }

    describe "for a signed-in user" do
      describe "for the club owner" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in user

          get 'show', :id => club.id
        end

        it "returns http redirect" do
          response.should be_redirect
        end

        it "redirects to the club name view" do
          response.should redirect_to(club_path(club))
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

        it "returns http redirect" do
          response.should be_redirect
        end

        it "redirects to the club name view" do
          response.should redirect_to(club_path(club))
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

        it "renders the application layout" do
          response.should render_template(:layout => "layouts/application")
        end
      end

      describe "for club belonging to user" do
        before :each do
          get 'edit', :id => user.clubs.first.id
        end

        it "returns http redirect" do
          response.should be_redirect
        end

        it "redirects the user to the club name path" do
          response.should redirect_to(club_editor_path(user.clubs.first.id))
        end

        it "returns the club" do
          assigns(:club).should_not be_nil
        end

        it "renders the mercury layout" do
          response.should render_template(:layout => "layouts/mercury")
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
        put 'update', :id => club.id, :content => { :club_name                => { :value => new_name },
                                                    :club_sub_heading         => { :value => "abc" },
                                                    :club_description         => { :value => "123" },
                                                    :club_courses_heading     => { :value => "456" },
                                                    :club_articles_heading    => { :value => "1ty" },
                                                    :club_discussions_heading => { :value => "tad" },
                                                    :club_logo                => { :attributes => { :src => "abc" } } }
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
        put 'update', :id => club.id, :content => { :club_name                => { :value => "" },
                                                    :club_sub_heading         => { :value => "" },
                                                    :club_description         => { :value => "" },
                                                    :club_courses_heading     => { :value => "" },
                                                    :club_articles_heading    => { :value => "" },
                                                    :club_discussions_heading => { :value => "" },
                                                    :club_logo                => { :attributes => { :src => "abc" } } }
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

  describe "PUT 'update_free_content'" do
    let(:club)             { user.clubs.first }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    describe "for valid attributes" do
      before :each do
        put 'update_free_content', :id => club.id, :club => { :free_content => { :value => false } }
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end

      it "assigns the new free_content attribute" do
        club.reload
        club.free_content.should == false
      end
    end

    describe "for invalid attributes" do
      before :each do
        @old_content = club.free_content
        put 'update_free_content', :id => club.id, :club => { :free_content => "" }
      end

      it "returns http unprocessable" do
        response.response_code.should == 422
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end

      it "does not update the attributes" do
        club.reload
        club.free_content.should == @old_content
      end
    end
  end

  describe "GET 'specify_price'" do
    let!(:club) { user.clubs.first }

    describe "for a signed-in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user
      end

      describe "who owns the club" do
        before :each do
          get 'specify_price', :format => :js, :id => club.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "assigns the club" do
          assigns(:club).should == club
        end
      end

      describe "who does not own the club" do
        let!(:other_user) { FactoryGirl.create :user }

        before :each do
          get 'specify_price', :format => :js, :id => other_user.clubs.first.id
        end

        it "returns 403 unauthorized forbidden code" do
          response.response_code.should == 403
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'specify_price', :format => :js, :id => club.id
      end

      it "renders the sign in view" do
        response.should render_template("devise/sessions/new")
      end
    end
  end

  describe "PUT 'update_price'" do
    let!(:club) { user.clubs.first }

    describe "for a signed-in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user
      end

      describe "attempting to update their own club price" do
        describe "for valid attributes" do
          let(:club_price) { "12.00" }

          before :each do
            put 'update_price', :format => :js, :id => club.id, :club_price => club_price
          end

          it "returns http success" do
            response.should be_success
          end

          it "returns the club" do
            assigns(:club).should == club
          end

          it "assigns the new attributes" do
            club.reload
            club.price.should == club_price
          end
        end

        describe "for invalid attributes" do
          let(:club_price) { "1" }

          before :each do
            @original_club_price = club.price
            put 'update_price', :format => :js, :id => club.id, :club_price => club_price
          end

          it "returns the club" do
            assigns(:club).should == club
          end

          it "does not update the attributes" do
            club.reload
            club.price.should == @original_club_price
          end

          it "returns an error" do
            flash[:error].should_not be_blank
          end
        end
      end

      describe "attempting to update another user's club" do
        let!(:other_user) { FactoryGirl.create :user }

        before :each do
          put 'update_price', :format => :js, :id => other_user.clubs.first.id, :club_price => "22.00"
        end

        it "returns http forbidden" do
          response.response_code.should == 403
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        put 'update_price', :format => :js, :id => user.id, :club_price => "22.00"
      end

      it "renders the sign in view" do
        response.should render_template("devise/sessions/new")
      end
    end
  end
end
