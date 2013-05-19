require 'spec_helper'

describe CoursesController do
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
    let(:course) { FactoryGirl.create :course }

    before :each do
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
end
