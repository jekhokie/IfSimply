require 'spec_helper'

describe Blog do
  it { should belong_to :club }

  it { should have_attached_file :image }

  it "can be instantiated" do
    Blog.new.should be_an_instance_of(Blog)
  end

  describe "valid?" do
    # title
    it "returns false when no title is specified" do
      FactoryGirl.build(:blog, :title => "").should_not be_valid
    end

    # content
    it "returns false when no content is specified" do
      FactoryGirl.build(:blog, :content => "").should_not be_valid
    end

    # image
    it { should validate_attachment_content_type(:image)
           .allowing('image/jpeg', 'image/png', 'image/gif')
           .rejecting('text/plain') }
  end

  describe "user" do
    let(:club) { FactoryGirl.create :club }

    it "returns the corresponding blog's user" do
      FactoryGirl.create(:blog, :club_id => club.id).user.should == club.user
    end
  end

  describe "assign_defaults" do
    let(:club) { FactoryGirl.create :club }

    before :each do
      @blog = Blog.new
      @blog.club_id = club.id
      @blog.assign_defaults
      @blog.save
    end

    it "assigns the correct default title" do
      @blog.title.should == Settings.blogs[:default_title]
    end

    it "assigns the correct default content" do
      @blog.content.should == Settings.blogs[:default_content]
    end

    it "assigns the correct default free boolean" do
      @blog.free.should == Settings.blogs[:default_free]
    end
  end
end
