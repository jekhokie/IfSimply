require 'spec_helper'

describe SalesPage do
  it { should belong_to :club }

  it "can be instantiated" do
    SalesPage.new.should be_an_instance_of(SalesPage)
  end

  describe "initialize" do
    let!(:club) { FactoryGirl.create(:user).clubs.first }
  end

  describe "valid?" do
    # heading
    it "returns false when no heading is specified" do
      FactoryGirl.build(:sales_page, :heading => "").should_not be_valid
    end

    # sub_heading
    it "returns false when no sub_heading is specified" do
      FactoryGirl.build(:sales_page, :sub_heading => "").should_not be_valid
    end

    # call_to_action
    it "returns false when no call_to_action is specified" do
      FactoryGirl.build(:sales_page, :call_to_action => "").should_not be_valid
    end

    # call_details
    it "returns false when no call_details is specified" do
      FactoryGirl.build(:sales_page, :call_details => "").should_not be_valid
    end

    # video
    describe "for video" do
      it "returns false when the URL is malformed" do
        FactoryGirl.build(:sales_page, :video => "bogus url").should_not be_valid
      end

      it "returns true when URL is blank/not specified" do
        FactoryGirl.build(:sales_page, :video => "").should be_valid
      end

      it "returns true for a youtube video of type youtube" do
        FactoryGirl.build(:sales_page, :video => "http://www.youtube.com/embed/xaELqAo4kkQ").should be_valid
      end

      it "returns true for a youtube video of type youtu.be" do
        FactoryGirl.build(:sales_page, :video => "http://youtu.be/xaELqAo4kkQ").should be_valid
      end

      it "returns true for a vimeo video" do
        FactoryGirl.build(:sales_page, :video => "http://vimeo.com/22977143").should be_valid
      end

      it "returns true for a slideshare presentation" do
        FactoryGirl.build(:sales_page, :video => "http://www.slideshare.net/slideshow/embed_code/28625239").should be_valid
      end

      it "returns false for a non-youtube/vimeo/slideshare link" do
        FactoryGirl.build(:sales_page, :video => "http://www.google.com/").should_not be_valid
      end
    end

    # benefit1
    it "returns false when no benefit1 is specified" do
      FactoryGirl.build(:sales_page, :benefit1 => "").should_not be_valid
    end

    # benefit2
    it "returns false when no benefit2 is specified" do
      FactoryGirl.build(:sales_page, :benefit2 => "").should_not be_valid
    end

    # benefit3
    it "returns false when no benefit3 is specified" do
      FactoryGirl.build(:sales_page, :benefit3 => "").should_not be_valid
    end

    # details
    it "returns false when no details is specified" do
      FactoryGirl.build(:sales_page, :details => "").should_not be_valid
    end
  end

  describe "user" do
    let(:club) { FactoryGirl.create :club }

    before :each do
      FakeWeb.clean_registry
      FakeWeb.register_uri(:head, "http://vimeo.com/22977143", :body => "", :status => [ "200", "OK" ])
    end

    it "returns the corresponding sales_page's user" do
      FactoryGirl.create(:sales_page, :club_id => club.id).user.should == club.user
    end
  end

  describe "assign_defaults" do
    let(:club) { FactoryGirl.create :club }

    before :each do
      @sales_page = SalesPage.new
      @sales_page.club_id = club.id
      @sales_page.assign_defaults
      @sales_page.save
    end

    it "assigns the correct default heading" do
      @sales_page.heading.should == Settings.sales_pages[:default_heading]
    end

    it "assigns the correct default sub_heading" do
      @sales_page.sub_heading.should == Settings.sales_pages[:default_sub_heading]
    end

    it "assigns the correct default call_to_action" do
      @sales_page.call_to_action.should == Settings.sales_pages[:default_call_to_action]
    end

    it "assigns the correct default call_details" do
      @sales_page.call_details.should == Settings.sales_pages[:default_call_details]
    end

    it "assigns the correct default benefit1" do
      @sales_page.benefit1.should == Settings.sales_pages[:default_benefit1]
    end

    it "assigns the correct default benefit2" do
      @sales_page.benefit2.should == Settings.sales_pages[:default_benefit2]
    end

    it "assigns the correct default benefit3" do
      @sales_page.benefit3.should == Settings.sales_pages[:default_benefit3]
    end

    it "assigns the correct default details" do
      @sales_page.details.should == Settings.sales_pages[:default_details]
    end
  end
end
