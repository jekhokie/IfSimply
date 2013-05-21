require 'spec_helper'

describe Lesson do
  it { should belong_to :course }

  it "can be instantiated" do
    Lesson.new.should be_an_instance_of(Lesson)
  end

  describe "valid?" do
    # title
    it "returns false when no title is specified" do
      FactoryGirl.build(:lesson, :title => "").should_not be_valid
    end

    # description
    it "returns false when no background is specified" do
      FactoryGirl.build(:lesson, :background => "").should_not be_valid
    end

    # video
    describe "for video" do
      it "returns false when the URL is malformed" do
        FactoryGirl.build(:lesson, :video => "bogus url").should_not be_valid
      end

      it "returns true when the URL is reachable" do
        FactoryGirl.build(:lesson, :video => "http://www.google.com/").should be_valid
      end
    end
  end

  describe "club" do
    let(:course) { FactoryGirl.create :course }

    it "returns the corresponding courses' club" do
      FactoryGirl.create(:lesson, :course_id => course.id).club.should == course.club
    end
  end

  describe "user" do
    let(:club)   { FactoryGirl.create :club }
    let(:course) { FactoryGirl.create :course, :club_id => club }

    it "returns the corresponding course's user" do
      FactoryGirl.create(:lesson, :course_id => course.id).user.should == course.user
    end
  end

  describe "assign_defaults" do
    let(:course) { FactoryGirl.create :course }

    before :each do
      @lesson = Lesson.new
      @lesson.course_id = course.id
      @lesson.assign_defaults
      @lesson.save
    end

    it "assigns the correct default title" do
      @lesson.title.should == "Lesson 1 - #{Settings.lessons[:default_title]}"
    end

    it "assigns the correct default description" do
      @lesson.background.should == Settings.lessons[:default_background]
    end

    it "assigns the correct default free boolean" do
      @lesson.free.should == Settings.lessons[:default_free]
    end
  end
end
