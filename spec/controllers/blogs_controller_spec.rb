require 'spec_helper'

describe BlogsController do
  let(:user) { FactoryGirl.create :user }

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:users]
    sign_in user
  end

  describe "POST 'create'" do
    before :each do
      post 'create', :club_id => user.clubs.first.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "should render the edit view" do
      response.should render_template("blogs/edit")
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
  end

  describe "GET 'edit'" do
    let(:blog) { FactoryGirl.create :blog, :club_id => user.clubs.first.id }

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
  end

  describe "PUT 'update'" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    let(:blog)      { FactoryGirl.create :blog, :club_id => user.clubs.first.id }
    let(:new_title) { "Test Blog" }

    describe "for valid attributes" do
      before :each do
        put 'update', :id => blog.id, :blog => { :title => new_title }
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the course" do
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
        put 'update', :id => blog.id, :blog => { :title => "" }
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
  end

  describe "GET 'change_image'" do
    let(:blog) { FactoryGirl.create :blog, :club_id => user.clubs.first.id }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user

      put 'change_image', :id => blog.id, :format => :js
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the blog" do
      assigns(:blog).should == blog
    end
  end

  describe "PUT 'upload_image'" do
    let(:blog)          { FactoryGirl.create :blog, :club_id => user.clubs.first.id }
    let(:valid_image)   { fixture_file_upload('/soccer_ball.jpg', 'image/jpeg') }
    let(:invalid_image) { fixture_file_upload('/soccer_ball.txt', 'text/plain') }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    describe "for a valid image format" do
      before :each do
        put 'upload_image', :id => blog.id, :blog => { :image => valid_image }, :format => :js
      end

      it "returns http redirect" do
        response.should be_redirect
      end

      it "redirects to edit blog path" do
        response.should redirect_to edit_blog_path(blog)
      end

      it "returns the blog" do
        assigns(:blog).should == blog
      end

      it "assigns the blog image" do
        File.basename(assigns(:blog).image.to_s.sub(/\?.*/, '')).should == valid_image.original_filename
      end
    end

    describe "for an invalid image format" do
      before :each do
        put 'upload_image', :id => blog.id, :blog => { :image => invalid_image }, :format => :js
      end

      it "returns http success" do
        response.should be_success
      end

      it "renders change_image" do
        response.should render_template("blogs/change_image")
      end

      it "returns the blog" do
        assigns(:blog).should == blog
      end

      it "does not assign the blog image" do
        File.basename(assigns(:blog).image.to_s.sub(/\?.*/, '')).should_not == valid_image.original_filename
      end
    end
  end
end
