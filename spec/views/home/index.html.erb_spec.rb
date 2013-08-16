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

      it "displays a sign-up header button" do
        within ".sign-up-club" do
          page.should have_selector("a", :text => "Sign Up Now!")
        end
      end

      it "displays a sign-up main button" do
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

      it "displays a my club header button" do
        within ".sign-up-club" do
          page.should have_selector("span", :text => "My Club")
        end
      end

      it "displays a my club main button" do
        within ".submit-sign-up" do
          page.should have_selector("span", :text => "My Club")
        end
      end
    end
  end
end
