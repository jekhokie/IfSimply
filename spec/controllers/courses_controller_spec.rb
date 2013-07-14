require 'spec_helper'

describe CoursesController do
  let(:user) { FactoryGirl.create :user }

  describe "POST 'create'" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user

      post 'create', :club_id => user.clubs.first.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "should render the edit view" do
      response.should render_template("courses/edit")
    end

    it "returns the club" do
      assigns(:club).should_not be_nil
    end

    it "returns the course belonging to the club" do
      assigns(:course).should_not be_nil
      assigns(:course).club.should == assigns(:club)
    end

    it "assigns the default title" do
      assigns(:course).title.should == Settings.courses[:default_title]
    end

    it "assigns the default description" do
      assigns(:course).description.should == Settings.courses[:default_description]
    end
  end

  describe "GET 'edit'" do
    let(:course) { FactoryGirl.create :course, :club_id => user.clubs.first.id }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user

      get 'edit', :club_id => course.club.id, :id => course.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the club" do
      assigns(:club).should == course.club
    end

    it "returns the course" do
      assigns(:course).should == course
    end
  end

  describe "PUT 'update'" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    let(:course)    { FactoryGirl.create :course, :club_id => user.clubs.first.id }
    let(:new_title) { "Test Course" }

    describe "for valid attributes" do
      before :each do
        put 'update', :id => course.id, :course => { :title => new_title }
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the course" do
        assigns(:course).should_not be_nil
      end

      it "assigns the new attributes" do
        course.reload
        course.title.should == new_title
      end
    end

    describe "for invalid attributes" do
      before :each do
        @old_title = course.title
        put 'update', :id => course.id, :course => { :title => "" }
      end

      it "returns http unprocessable" do
        response.response_code.should == 422
      end

      it "returns the course" do
        assigns(:course).should_not be_nil
      end

      it "does not update the attributes" do
        course.reload
        course.title.should == @old_title
      end
    end
  end

  describe "GET 'change_logo'" do
    let(:course) { FactoryGirl.create :course, :club => user.clubs.first }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user

      put 'change_logo', :id => course.id, :format => :js
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the course" do
      assigns(:course).should == course
    end
  end

  describe "PUT 'upload_logo'" do
    let(:course)       { FactoryGirl.create :course, :club => user.clubs.first }
    let(:valid_logo)   { fixture_file_upload('/soccer_ball.jpg', 'image/jpeg') }
    let(:invalid_logo) { fixture_file_upload('/soccer_ball.txt', 'text/plain') }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    describe "for a valid image format" do
      before :each do
        put 'upload_logo', :id => course.id, :course => { :logo => valid_logo }, :format => :js
      end

      it "returns http success" do
        response.should be_success
      end

      it "renders the upload_logo template" do
        response.should render_template('courses/upload_logo')
      end

      it "returns the course" do
        assigns(:course).should == course
      end

      it "assigns the course logo" do
        File.basename(assigns(:course).logo.to_s.sub(/\?.*/, '')).should == valid_logo.original_filename
      end
    end

    describe "for an invalid image format" do
      before :each do
        put 'upload_logo', :id => course.id, :course => { :logo => invalid_logo }, :format => :js
      end

      it "returns http success" do
        response.should be_success
      end

      it "renders change_logo" do
        response.should render_template("courses/change_logo")
      end

      it "returns the course" do
        assigns(:course).should == course
      end

      it "does not assign the course logo" do
        File.basename(assigns(:course).logo.to_s.sub(/\?.*/, '')).should_not == valid_logo.original_filename
      end
    end

    describe "for a non-specified logo value" do
      before :each do
        put 'upload_logo', :id => course.id, :format => :js
      end

      it "returns http success" do
        response.should be_success
      end

      it "renders change_logo" do
        response.should render_template("courses/change_logo")
      end

      it "returns the course" do
        assigns(:course).should == course
      end

      it "does not assign the course logo" do
        File.basename(assigns(:course).logo.to_s.sub(/\?.*/, '')).should_not == valid_logo.original_filename
      end
    end
  end

  describe "GET 'show_all'" do
    let(:course) { FactoryGirl.create :course, :club => user.clubs.first }

    describe "for a signed-in user" do
      describe "for a subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => course.club }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribed_user

          get 'show_all', :club_id => course.club.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the courses show_all view" do
          response.should render_template("courses/show_all")
        end

        it "assigns club" do
          assigns(:club).should == user.clubs.first
        end

        it "assigns courses" do
          assigns(:courses).should include(course)
        end
      end

      describe "for a non-subscriber" do
        let!(:non_subscribed_user) { FactoryGirl.create :user }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in non_subscribed_user

          get 'show_all', :club_id => course.club.id
        end

        it "redirects to the sales page" do
          response.should redirect_to(club_sales_page_path(course.club))
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'show_all', :club_id => course.club.id
      end

      it "redirects to the sales page" do
        response.should redirect_to(club_sales_page_path(course.club))
      end
    end
  end
end
