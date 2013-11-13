require 'spec_helper'

describe Article do
  it { should belong_to :club }

  it "can be instantiated" do
    Article.new.should be_an_instance_of(Article)
  end

  describe "default sort order" do
    let!(:club)      { FactoryGirl.create :club }
    let!(:article_3) { FactoryGirl.create :article, :club => club, :created_at => Time.local(2013,"jan",5,20,15,45) }
    let!(:article_1) { FactoryGirl.create :article, :club => club, :created_at => Time.local(2013,"jan",2,20,15,45) }
    let!(:article_2) { FactoryGirl.create :article, :club => club, :created_at => Time.local(2013,"jan",2,20,17,45) }

    it "returns articles by created_at in ascending order" do
      club.articles.should == [ article_1, article_2, article_3 ]
    end
  end

  describe "valid?" do
    # title
    it "returns false when no title is specified" do
      FactoryGirl.build(:article, :title => "").should_not be_valid
    end

    # content
    it "returns false when no content is specified" do
      FactoryGirl.build(:article, :content => "").should_not be_valid
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

  describe "user" do
    let(:club) { FactoryGirl.create :club }

    it "returns the corresponding article's user" do
      FactoryGirl.create(:article, :club_id => club.id).user.should == club.user
    end
  end

  describe "pro?" do
    describe "for a pro article entry" do
      FactoryGirl.build(:article, :free => false).pro?.should == true
    end

    describe "for a free article entry" do
      FactoryGirl.build(:article, :free => true).pro?.should == false
    end
  end

  describe "assign_defaults" do
    let(:club) { FactoryGirl.create :club }

    before :each do
      @article = Article.new
      @article.club_id = club.id
      @article.assign_defaults
      @article.save
    end

    it "assigns the correct default title" do
      @article.title.should == Settings.articles[:default_title]
    end

    it "assigns the correct default content" do
      @article.content.should == Settings.articles[:default_content]
    end

    it "assigns the correct default free boolean" do
      @article.free.should == Settings.articles[:default_free]
    end

    it "assigns the correct default image" do
      @article.image.should == Settings.articles[:default_image]
    end
  end
end
