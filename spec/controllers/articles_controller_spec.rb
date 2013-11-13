require 'spec_helper'

describe ArticlesController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'show'" do
    let!(:club)    { user.clubs.first }
    let!(:article) { FactoryGirl.create :article, :club => club, :free => false }

    describe "for a signed-in user" do
      describe "for the club owner" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in user

          get 'show', :id => article.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the article show view" do
          response.should render_template("articles/show")
        end

        it "returns the article" do
          assigns(:article).should_not be_nil
        end
      end

      describe "for a basic subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => club, :level => 'basic' }

        describe "for a free article" do
          let!(:free_article) { FactoryGirl.create :article, :club => club, :free => true }

          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in subscribed_user

            get 'show', :id => free_article.id
          end

          it "returns http success" do
            response.should be_success
          end

          it "renders the article show view" do
            response.should render_template("articles/show")
          end

          it "returns the article" do
            assigns(:article).should_not be_nil
          end
        end

        describe "for a paid article" do
          let!(:paid_article) { FactoryGirl.create :article, :club => club, :free => false }

          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in subscribed_user

            get 'show', :id => paid_article.id
          end

          it "redirects to the sales page" do
            response.should redirect_to(club_sales_page_path(club))
          end

          it "returns the article" do
            assigns(:article).should_not be_nil
          end
        end
      end

      describe "for a pro subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => club, :level => 'pro', :pro_status => "ACTIVE" }

        describe "for a free article" do
          let!(:free_article) { FactoryGirl.create :article, :club => club, :free => true }

          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in subscribed_user

            get 'show', :id => free_article.id
          end

          it "returns http success" do
            response.should be_success
          end

          it "renders the article show view" do
            response.should render_template("articles/show")
          end

          it "returns the article" do
            assigns(:article).should_not be_nil
          end
        end

        describe "for a paid article" do
          let!(:paid_article) { FactoryGirl.create :article, :club => club, :free => false }

          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in subscribed_user

            get 'show', :id => paid_article.id
          end

          it "returns http success" do
            response.should be_success
          end

          it "renders the article show view" do
            response.should render_template("articles/show")
          end

          it "returns the article" do
            assigns(:article).should_not be_nil
          end
        end
      end

      describe "for a non-subscriber" do
        let!(:non_subscribed_user) { FactoryGirl.create :user }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in non_subscribed_user

          get 'show', :id => article.id
        end

        it "redirects to the sales page" do
          response.should redirect_to(club_sales_page_path(club))
        end

        it "returns the article" do
          assigns(:article).should_not be_nil
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'show', :id => article.id
      end

      it "redirects to the sales page" do
        response.should redirect_to(club_sales_page_path(club))
      end

      it "returns the article" do
        assigns(:article).should_not be_nil
      end
    end
  end

  describe "POST 'create'" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user

      post 'create', :club_id => user.clubs.first.id
    end

    it "redirects to the edit view" do
      response.should redirect_to(article_editor_path(assigns(:article)))
    end

    it "returns the club" do
      assigns(:club).should_not be_nil
    end

    it "returns the article belonging to the club" do
      assigns(:article).should_not be_nil
      assigns(:article).club.should == assigns(:club)
    end

    it "assigns the default title" do
      assigns(:article).title.should == Settings.articles[:default_title]
    end

    it "assigns the default content" do
      assigns(:article).content.should == Settings.articles[:default_content]
    end

    it "assigns the default image" do
      assigns(:article).image.should == Settings.articles[:default_image]
    end
  end

  describe "GET 'edit'" do
    let(:article) { FactoryGirl.create :article, :club_id => user.clubs.first.id }

    describe "for a non signed-in user" do
      describe "for a article not belonging to user" do
        it "redirects for user sign in" do
          get 'edit', :id => FactoryGirl.create(:article).id

          response.should be_redirect
          response.should redirect_to new_user_session_path
        end
      end

      describe "for a article belonging to user" do
        it "redirects for user sign in" do
          get 'edit', :id => article

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

      describe "for article not belonging to user" do
        before :each do
          get 'edit', :id => FactoryGirl.create(:article).id
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

      describe "for article belonging to user" do
        before :each do
          get 'edit', :id => article.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "returns the club" do
          assigns(:club).should == article.club
        end

        it "returns the article" do
          assigns(:article).should == article
        end

        it "renders the mercury layout" do
          response.should render_template(:layout => "layouts/mercury")
        end
      end
    end
  end

  describe "PUT 'update'" do
    let(:article)   { FactoryGirl.create :article, :club_id => user.clubs.first.id }
    let(:new_title) { "Test Article" }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    describe "for valid attributes" do
      before :each do
        put 'update', :id => article.id, :content => { :article_title   => { :value => new_title },
                                                       :article_content => { :value => "123" },
                                                       :article_image   => { :attributes => { :src => "abc" } } }
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the article" do
        assigns(:article).should_not be_nil
      end

      it "assigns the new attributes" do
        article.reload
        article.title.should == new_title
      end
    end

    describe "for invalid attributes" do
      before :each do
        @old_title = article.title
        put 'update', :id => article.id, :content => { :article_title   => { :value => "" },
                                                       :article_content => { :value => "123" },
                                                       :article_image   => { :attributes => { :src => "abc" } } }
      end

      it "returns http unprocessable" do
        response.response_code.should == 422
      end

      it "returns the article" do
        assigns(:article).should_not be_nil
      end

      it "does not update the attributes" do
        article.reload
        article.title.should == @old_title
      end
    end

    describe "for the free attribute" do
      describe "for valid attributes" do
        before :each do
          put 'update', :id => article.id, :article => { :free => true }
        end

        it "returns http success" do
          response.should be_success
        end

        it "returns the article" do
          assigns(:article).should == article
        end

        it "assigns the new attributes" do
          article.reload
          article.free.should == true
        end
      end

      describe "for invalid attributes" do
        before :each do
          @old_free = article.free
          put 'update', :id => article.id, :article => { :free => "" }
        end

        it "returns http unprocessable" do
          response.response_code.should == 422
        end

        it "returns the article" do
          assigns(:article).should == article
        end

        it "does not update the attributes" do
          article.reload
          article.free.should == @old_free
        end
      end
    end
  end

  describe "GET 'show_all'" do
    let(:article) { FactoryGirl.create :article, :club => user.clubs.first }

    describe "for a signed-in user" do
      describe "for the club owner" do
        let!(:club_owner)    { FactoryGirl.create :user }
        let!(:owned_article) { FactoryGirl.create :article, :club => club_owner.clubs.first }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in club_owner

          get 'show_all', :club_id => owned_article.club.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the article show_all view" do
          response.should render_template("articles/show_all")
        end

        it "assigns club" do
          assigns(:club).should == club_owner.clubs.first
        end

        it "assigns articles" do
          assigns(:articles).should include(owned_article)
        end
      end

      describe "for a subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => article.club }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribed_user

          get 'show_all', :club_id => article.club.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the article show_all view" do
          response.should render_template("articles/show_all")
        end

        it "assigns club" do
          assigns(:club).should == user.clubs.first
        end

        it "assigns articles" do
          assigns(:articles).should include(article)
        end
      end

      describe "for a non-subscriber" do
        let!(:non_subscribed_user) { FactoryGirl.create :user }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in non_subscribed_user

          get 'show_all', :club_id => article.club.id
        end

        it "redirects to the sales page" do
          response.should redirect_to(club_sales_page_path(article.club))
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'show_all', :club_id => article.club.id
      end

      it "redirects to the sales page" do
        response.should redirect_to(club_sales_page_path(article.club))
      end
    end
  end
end
