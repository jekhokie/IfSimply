require 'spec_helper'

describe LessonsController do
  let(:user) { FactoryGirl.create :user }

  describe "POST 'create'" do
    let(:course) { FactoryGirl.create :course, :club_id => user.clubs.first.id }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user

      post 'create', :course_id => course.id
    end

    it "returns http redirect" do
      response.should be_redirect
    end

    it "should redirect to the edit course path" do
      response.should redirect_to(course_editor_path(course))
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

  describe "PUT 'update'" do
    let(:course) { FactoryGirl.create :course, :club_id => user.clubs.first.id }
    let(:lesson) { FactoryGirl.create :lesson, :course_id => course.id }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    describe "for valid attributes" do
      before :each do
        put 'update', :course_id => course.id, :id => lesson.id, :lesson => { :free => true }
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the course" do
        assigns(:course).should == course
      end

      it "returns the lesson" do
        assigns(:lesson).should == lesson
      end

      it "assigns the new attributes" do
        lesson.reload
        lesson.free.should == true
      end
    end

    describe "for invalid attributes" do
      before :each do
        @old_free = lesson.free
        put 'update', :course_id => course.id, :id => lesson.id, :lesson => { :free => "" }
      end

      it "returns http unprocessable" do
        response.response_code.should == 422
      end

      it "returns the course" do
        assigns(:course).should == course
      end

      it "returns the lesson" do
        assigns(:lesson).should == lesson
      end

      it "does not update the attributes" do
        lesson.reload
        lesson.free.should == @old_free
      end
    end
  end
end
