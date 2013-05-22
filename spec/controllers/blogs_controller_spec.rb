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
end
