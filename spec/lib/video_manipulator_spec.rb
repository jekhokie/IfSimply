require 'spec_helper'

describe "VideoManipulator lib" do
  describe ".validate_url(video_url)" do
    it "returns false for a malformed URL" do
      VideoManipulator.validate_url("AbcdEEfg").should == false
    end

    it "returns false for a non-reachable URL" do
      VideoManipulator.validate_url("http://something.not.really").should == false
    end

    it "returns true for a valid reachable URL" do
      VideoManipulator.validate_url("http://www.google.com/").should == true
    end
  end
end
