require 'spec_helper'

describe Course do
  it { should belong_to :club }

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
end
