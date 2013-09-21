require 'spec_helper'

describe BlogsController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'show'" do
    let!(:club) { user.clubs.first }
    let!(:blog) { FactoryGirl.create :blog, :club => club, :free => false }

    describe "for a signed-in user" do
      describe "for the club owner" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in user

          get 'show', :id => blog.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the blog show view" do
          response.should render_template("blogs/show")
        end

        it "returns the blog" do
          assigns(:blog).should_not be_nil
        end
      end

      describe "for a basic subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => club, :level => :basic }

        describe "for a free blog" do
          let!(:free_blog) { FactoryGirl.create :blog, :club => club, :free => true }

          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in subscribed_user

            get 'show', :id => free_blog.id
          end

          it "returns http success" do
            response.should be_success
          end

          it "renders the blog show view" do
            response.should render_template("blogs/show")
          end

          it "returns the blog" do
            assigns(:blog).should_not be_nil
          end
        end

        describe "for a paid blog" do
          let!(:paid_blog) { FactoryGirl.create :blog, :club => club, :free => false }

          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in subscribed_user

            get 'show', :id => paid_blog.id
          end

          it "redirects to the sales page" do
            response.should redirect_to(club_sales_page_path(club))
          end

          it "returns the blog" do
            assigns(:blog).should_not be_nil
          end
        end
      end

      describe "for a pro subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => club, :level => :pro, :pro_active => true }

        describe "for a free blog" do
          let!(:free_blog) { FactoryGirl.create :blog, :club => club, :free => true }

          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in subscribed_user

            get 'show', :id => free_blog.id
          end

          it "returns http success" do
            response.should be_success
          end

          it "renders the blog show view" do
            response.should render_template("blogs/show")
          end

          it "returns the blog" do
            assigns(:blog).should_not be_nil
          end
        end

        describe "for a paid blog" do
          let!(:paid_blog) { FactoryGirl.create :blog, :club => club, :free => false }

          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in subscribed_user

            get 'show', :id => paid_blog.id
          end

          it "returns http success" do
            response.should be_success
          end

          it "renders the blog show view" do
            response.should render_template("blogs/show")
          end

          it "returns the blog" do
            assigns(:blog).should_not be_nil
          end
        end
      end

      describe "for a non-subscriber" do
        let!(:non_subscribed_user) { FactoryGirl.create :user }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in non_subscribed_user

          get 'show', :id => blog.id
        end

        it "redirects to the sales page" do
          response.should redirect_to(club_sales_page_path(club))
        end

        it "returns the blog" do
          assigns(:blog).should_not be_nil
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'show', :id => blog.id
      end

      it "redirects to the sales page" do
        response.should redirect_to(club_sales_page_path(club))
      end

      it "returns the blog" do
        assigns(:blog).should_not be_nil
      end
    end
  end

  describe "POST 'create'" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user

      post 'create', :club_id => user.clubs.first.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "renders the mercury layout" do
      response.should render_template(:layout => "layouts/mercury")
    end

    it "returns the club" do
      assigns(:club).should_not be_nil
    end

    it "returns the course belonging to the club" do
      assigns(:blog).should_not be_nil
      assigns(:blog).club.should == assigns(:club)
    end

    it "assigns the default title" do
      assigns(:blog).title.should == Settings.blogs[:default_title]
    end

    it "assigns the default content" do
      assigns(:blog).content.should == Settings.blogs[:default_content]
    end

    it "assigns the default image" do
      assigns(:blog).image.should == Settings.blogs[:default_image]
    end
  end

  describe "GET 'edit'" do
    let(:blog) { FactoryGirl.create :blog, :club_id => user.clubs.first.id }

    describe "for a non signed-in user" do
      describe "for a blog not belonging to user" do
        it "redirects for user sign in" do
          get 'edit', :id => FactoryGirl.create(:blog).id

          response.should be_redirect
          response.should redirect_to new_user_session_path
        end
      end

      describe "for a blog belonging to user" do
        it "redirects for user sign in" do
          get 'edit', :id => blog

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

      describe "for blog not belonging to user" do
        before :each do
          get 'edit', :id => FactoryGirl.create(:blog).id
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

      describe "for blog belonging to user" do
        before :each do
          get 'edit', :id => blog.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "returns the club" do
          assigns(:club).should == blog.club
        end

        it "returns the blog" do
          assigns(:blog).should == blog
        end

        it "renders the mercury layout" do
          response.should render_template(:layout => "layouts/mercury")
        end
      end
    end
  end

  describe "PUT 'update'" do
    let(:blog)      { FactoryGirl.create :blog, :club_id => user.clubs.first.id }
    let(:new_title) { "Test Blog" }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    describe "for valid attributes" do
      before :each do
        put 'update', :id => blog.id, :content => { :blog_title   => { :value => new_title },
                                                    :blog_content => { :value => "123" },
                                                    :blog_image   => { :attributes => { :src => "abc" } } }
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the blog" do
        assigns(:blog).should_not be_nil
      end

      it "assigns the new attributes" do
        blog.reload
        blog.title.should == new_title
      end
    end

    describe "for invalid attributes" do
      before :each do
        @old_title = blog.title
        put 'update', :id => blog.id, :content => { :blog_title   => { :value => "" },
                                                    :blog_content => { :value => "123" },
                                                    :blog_image   => { :attributes => { :src => "abc" } } }
      end

      it "returns http unprocessable" do
        response.response_code.should == 422
      end

      it "returns the blog" do
        assigns(:blog).should_not be_nil
      end

      it "does not update the attributes" do
        blog.reload
        blog.title.should == @old_title
      end
    end

    describe "for the free attribute" do
      describe "for valid attributes" do
        before :each do
          put 'update', :id => blog.id, :blog => { :free => true }
        end

        it "returns http success" do
          response.should be_success
        end

        it "returns the blog" do
          assigns(:blog).should == blog
        end

        it "assigns the new attributes" do
          blog.reload
          blog.free.should == true
        end
      end

      describe "for invalid attributes" do
        before :each do
          @old_free = blog.free
          put 'update', :id => blog.id, :blog => { :free => "" }
        end

        it "returns http unprocessable" do
          response.response_code.should == 422
        end

        it "returns the blog" do
          assigns(:blog).should == blog
        end

        it "does not update the attributes" do
          blog.reload
          blog.free.should == @old_free
        end
      end
    end
  end

  describe "GET 'show_all'" do
    let(:blog) { FactoryGirl.create :blog, :club => user.clubs.first }

    describe "for a signed-in user" do
      describe "for the club owner" do
        let!(:club_owner) { FactoryGirl.create :user }
        let!(:owned_blog) { FactoryGirl.create :blog, :club => club_owner.clubs.first }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in club_owner

          get 'show_all', :club_id => owned_blog.club.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the blog show_all view" do
          response.should render_template("blogs/show_all")
        end

        it "assigns club" do
          assigns(:club).should == club_owner.clubs.first
        end

        it "assigns blogs" do
          assigns(:blogs).should include(owned_blog)
        end
      end

      describe "for a subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => blog.club }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribed_user

          get 'show_all', :club_id => blog.club.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the blog show_all view" do
          response.should render_template("blogs/show_all")
        end

        it "assigns club" do
          assigns(:club).should == user.clubs.first
        end

        it "assigns blogs" do
          assigns(:blogs).should include(blog)
        end
      end

      describe "for a non-subscriber" do
        let!(:non_subscribed_user) { FactoryGirl.create :user }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in non_subscribed_user

          get 'show_all', :club_id => blog.club.id
        end

        it "redirects to the sales page" do
          response.should redirect_to(club_sales_page_path(blog.club))
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'show_all', :club_id => blog.club.id
      end

      it "redirects to the sales page" do
        response.should redirect_to(club_sales_page_path(blog.club))
      end
    end
  end
end
