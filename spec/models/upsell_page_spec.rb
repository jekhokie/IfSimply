require 'spec_helper'

describe UpsellPage do
  it { should belong_to :club }

  it "can be instantiated" do
    UpsellPage.new.should be_an_instance_of(UpsellPage)
  end

  describe "initialize" do
    let!(:upsell_page) { FactoryGirl.create(:user).clubs.first.upsell_page }

    it "assigns the default heading" do
      upsell_page.heading.should == Settings.upsell_pages[:default_heading]
    end

    it "assigns the default sub_heading" do
      upsell_page.sub_heading.should == Settings.upsell_pages[:default_sub_heading]
    end

    it "assigns the default basic_articles_desc" do
      upsell_page.basic_articles_desc.should == Settings.upsell_pages[:default_basic_articles_desc]
    end

    it "assigns the default exclusive_articles_desc" do
      upsell_page.exclusive_articles_desc.should == Settings.upsell_pages[:default_exclusive_articles_desc]
    end

    it "assigns the default basic_courses_desc" do
      upsell_page.basic_courses_desc.should == Settings.upsell_pages[:default_basic_courses_desc]
    end

    it "assigns the default in_depth_courses_desc" do
      upsell_page.in_depth_courses_desc.should == Settings.upsell_pages[:default_in_depth_courses_desc]
    end

    it "assigns the default discussion_forums_desc" do
      upsell_page.discussion_forums_desc.should == Settings.upsell_pages[:default_discussion_forums_desc]
    end
  end

  describe "valid?" do
    # heading
    it "returns false when no heading is specified" do
      FactoryGirl.build(:upsell_page, :heading => "").should_not be_valid
    end

    # sub_heading
    it "returns false when no sub_heading is specified" do
      FactoryGirl.build(:upsell_page, :sub_heading => "").should_not be_valid
    end

    # basic_articles_desc
    it "returns false when no basic_articles_desc is specified" do
      FactoryGirl.build(:upsell_page, :basic_articles_desc => "").should_not be_valid
    end

    # exclusive_articles_desc
    it "returns false when no exclusive_articles_desc is specified" do
      FactoryGirl.build(:upsell_page, :exclusive_articles_desc => "").should_not be_valid
    end

    # basic_courses_desc
    it "returns false when no basic_courses_desc is specified" do
      FactoryGirl.build(:upsell_page, :basic_courses_desc => "").should_not be_valid
    end

    # in_depth_courses_desc
    it "returns false when no in_depth_courses_desc is specified" do
      FactoryGirl.build(:upsell_page, :in_depth_courses_desc => "").should_not be_valid
    end

    # discussion_forums_desc
    it "returns false when no discussion_forums_desc is specified" do
      FactoryGirl.build(:upsell_page, :discussion_forums_desc => "").should_not be_valid
    end
  end
end
