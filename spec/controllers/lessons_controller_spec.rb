require 'spec_helper'

describe LessonsController do
  let(:user) { FactoryGirl.create :user }

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:users]
    sign_in user
  end

  describe "POST 'create'" do
    let(:course) { FactoryGirl.create :course, :club_id => user.clubs.first.id }

    before :each do
      post 'create', :course_id => course.id
    end

    it "returns http redirect" do
      response.should be_redirect
    end

    it "should redirect to the edit course path" do
      response.should redirect_to(edit_course_path(course))
    end

    it "returns the course" do
      assigns(:course).should == course
    end

    it "returns the lesson belonging to the course" do
      assigns(:lesson).should_not be_nil
      assigns(:lesson).course.should == assigns(:course)
    end

    it "assigns the default title" do
      assigns(:lesson).title.should == "Lesson 1 - #{Settings.lessons[:default_title]}"
    end

    it "assigns the default background" do
      assigns(:lesson).background.should == Settings.lessons[:default_background]
    end
  end
end
