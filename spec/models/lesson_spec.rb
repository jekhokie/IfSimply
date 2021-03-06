require 'spec_helper'

describe Lesson do
  it { should belong_to :course }

  # file_attachment via PaperClip
  it { should have_attached_file(:file_attachment) }
  it { should validate_attachment_content_type(:file_attachment).
                allowing('audio/mpeg', 'audio/mp3', 'video/x-ms-wav', 'video/x-ms-wmv', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.openxmlformats-officedocument.spreadsheetml.template', 'application/vnd.openxmlformats-officedocument.presentationml.template', 'application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.slideshow', 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 'application/vnd.openxmlformats-officedocument.presentationml.slide', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.openxmlformats-officedocument.wordprocessingml.template', 'application/vnd.ms-excel.addin.macroEnabled.12', 'application/vnd.ms-excel.sheet.binary.macroEnabled.12', 'application/vnd.ms-excel', 'application/msword', 'application/pdf', 'application/octet-stream', 'text/plain', 'text/rtf', 'text/richtext')
     }
  it { should validate_attachment_size(:file_attachment).in(0..10000.kilobytes) }

  it "can be instantiated" do
    Lesson.new.should be_an_instance_of(Lesson)
  end

  describe "valid?" do
    before :each do
      FakeWeb.clean_registry
      FakeWeb.register_uri(:head, "http://vimeo.com/22977143", :body => "", :status => [ "200", "OK" ])
    end

    # title
    it "returns false when no title is specified" do
      FactoryGirl.build(:lesson, :title => "").should_not be_valid
    end

    # background
    it "returns false when no background is specified" do
      FactoryGirl.build(:lesson, :background => "").should_not be_valid
    end

    # video
    describe "for video" do
      it "returns false when the URL is malformed" do
        FactoryGirl.build(:lesson, :video => "bogus url").should_not be_valid
      end

      it "returns true when URL is blank/not specified" do
        FactoryGirl.build(:lesson, :video => "").should be_valid
      end

      it "returns true for a youtube video of type youtube" do
        FactoryGirl.build(:lesson, :video => "http://www.youtube.com/embed/xaELqAo4kkQ").should be_valid
      end

      it "returns true for a youtube video of type youtu.be" do
        FactoryGirl.build(:lesson, :video => "http://youtu.be/xaELqAo4kkQ").should be_valid
      end

      it "returns true for a vimeo video" do
        FactoryGirl.build(:lesson, :video => "http://vimeo.com/22977143").should be_valid
      end

      it "returns true for a slideshare presentation" do
        FactoryGirl.build(:lesson, :video => "http://www.slideshare.net/slideshow/embed_code/28625239").should be_valid
      end

      it "returns false for a non-youtube/vimeo/slideshare link" do
        FactoryGirl.build(:lesson, :video => "http://www.google.com/").should_not be_valid
      end
    end

    # free
    describe "for free" do
      it "returns false when no free is specified" do
        FactoryGirl.build(:lesson, :free => "").should_not be_valid
      end

      it "returns true when free is a string of a boolean" do
        FactoryGirl.build(:lesson, :free => true).should be_valid
      end
    end
  end

  describe "club" do
    let(:course) { FactoryGirl.create :course }

    it "returns the corresponding courses' club" do
      FactoryGirl.create(:lesson, :course => course).club.should == course.club
    end
  end

  describe "user" do
    let(:club)   { FactoryGirl.create :club }
    let(:course) { FactoryGirl.create :course, :club => club }

    it "returns the corresponding course's user" do
      FactoryGirl.create(:lesson, :course_id => course.id).user.should == course.user
    end
  end

  describe "assign_defaults" do
    before :each do
      @course = FactoryGirl.create :course

      @lesson = Lesson.new
      @lesson.course_id = @course.id
      @lesson.assign_defaults
      @lesson.save
    end

    it "assigns the correct default free boolean" do
      @lesson.free.should == Settings.lessons[:default_free]
    end

    it "assigns the correct default initial title" do
      @lesson.title.should == "Lesson 1 - #{Settings.lessons[:default_initial_title]}"
    end

    it "assigns the correct default initial background" do
      @lesson.background.should == Settings.lessons[:default_initial_background]
    end

    it "assigns the correct default initial video" do
      @lesson.video.should == Settings.lessons[:default_initial_video]
    end

    describe "for the non-first Lesson of a Course" do
      before :each do
        lesson  = FactoryGirl.create :lesson

        @new_lesson = Lesson.new
        @new_lesson.course_id = lesson.course.id
        @new_lesson.assign_defaults
        @new_lesson.save
      end

      it "assigns the correct default free boolean" do
        @new_lesson.free.should == Settings.lessons[:default_free]
      end

      it "assigns the correct default non-initial title" do
        @new_lesson.title.should == "Lesson 2 - #{Settings.lessons[:default_title]}"
      end

      it "assigns the correct default non-initial background" do
        @new_lesson.background.should == Settings.lessons[:default_background]
      end

      it "does not assign a default video" do
        @new_lesson.video.should be_blank
      end
    end

    describe "for a Lesson of a Course that is not the only Course" do
      before :each do
        course1 = FactoryGirl.create(:course)
        course2 = FactoryGirl.create(:course, :club_id => course1.club.id)

        @new_lesson = Lesson.new
        @new_lesson.course_id = course2.id
        @new_lesson.assign_defaults
        @new_lesson.save
      end

      it "assigns the correct default free boolean" do
        @new_lesson.free.should == Settings.lessons[:default_free]
      end

      it "assigns the correct default initial title" do
        @new_lesson.title.should == "Lesson 1 - #{Settings.lessons[:default_initial_title]}"
      end

      it "assigns the correct default initial background" do
        @new_lesson.background.should == Settings.lessons[:default_initial_background]
      end

      it "assigns the correct default initial video" do
        @new_lesson.video.should == Settings.lessons[:default_initial_video]
      end
    end
  end
end
