require 'spec_helper'

describe Course do
  it { should belong_to :club }
  it { should have_many :lessons }

  it "can be instantiated" do
    Course.new.should be_an_instance_of(Course)
  end

  describe "valid?" do
    # title
    it "returns false when no title is specified" do
      FactoryGirl.build(:course, :title => "").should_not be_valid
    end

    # description
    it "returns false when no description is specified" do
      FactoryGirl.build(:course, :description => "").should_not be_valid
    end

    # club association
    it "returns false when missing a club_id" do
      FactoryGirl.build(:course, :club_id => nil).should_not be_valid
    end
  end

  describe "assign_defaults" do
    let(:club) { FactoryGirl.create :club }

    before :each do
      @course = Course.new
      @course.club_id = club.id
      @course.assign_defaults
      @course.save
    end

    it "assigns the correct default title" do
      @course.title.should == Settings.courses[:default_title]
    end

    it "assigns the correct default description" do
      @course.description.should == Settings.courses[:default_description]
    end

    describe "for a Club that has no other Courses" do
      it "assigns the default initial logo" do
        @course.logo.to_s.should == Settings.courses[:default_initial_logo]
      end
    end

    describe "for a Club that has other Courses" do
      before :each do
        @new_course = Course.new
        @new_course.club_id = club.id
        @new_course.assign_defaults
        @new_course.save
      end

      it "assigns the default non-initial logo" do
        @new_course.logo.to_s.should == Settings.courses[:default_logo]
      end
    end
  end

  describe "user" do
    let(:club) { FactoryGirl.create :club }

    it "returns the corresponding clubs' user" do
      FactoryGirl.create(:course, :club_id => club.id).user.should == club.user
    end
  end

  describe "lessons" do
    before :each do
      @course = FactoryGirl.create :course
      FactoryGirl.create :lesson, :course_id => @course.id
    end

    it "should be destroyed when the course is destroyed" do
      expect { @course.destroy }.to change(Lesson, :count).by(-1)
    end
  end
end
