require 'spec_helper'

describe SessionsController do
  describe "'after_sign_in_path_for'" do
    let!(:club) { FactoryGirl.create :club }

    describe "for a subscription request" do
      before :each do
        session[:subscription] = FactoryGirl.create :subscription, :club => club
      end

      it "returns the subscribe_to_club_path" do
        subject.send(:after_sign_in_path_for, User.new).should == subscribe_to_club_path(club)
      end
    end

    describe "for a normal sign in" do
      it "returns the home page" do
        subject.send(:after_sign_in_path_for, User.new).should == "/"
      end
    end
  end
end
