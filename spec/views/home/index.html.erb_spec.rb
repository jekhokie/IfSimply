require 'spec_helper'

describe "home/learn_more.html.erb" do
  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { FactoryGirl.create :user }

  describe "GET '/index'" do
    describe "for a non signed-in guest" do
      before :each do
        visit '/'
      end

      it "should display a sign-up button" do
        within ".submit-sign-up" do
          page.should have_selector("span", :text => "Start A Club Now")
        end
      end
    end

    describe "for a signed-in user" do
      before :each do
        user = FactoryGirl.create :user
        user.confirm!
        login_as user, :scope => :user

        visit '/'
      end

      it "should display a my club button" do
        within ".submit-sign-up" do
          page.should have_selector("span", :text => "My Club")
        end
      end
    end
  end
end
