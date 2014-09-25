require 'spec_helper'

describe "home/index.html.erb" do
  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { FactoryGirl.create :user }

  describe "GET '/index'" do
    describe "for a non signed-in guest" do
      before :each do
        visit '/'
      end

      it "displays a Get Started header button" do
        within ".sign-up-club" do
          page.should have_selector("a", :text => "Get Started!")
        end
      end

      it "displays a learn more top button" do
        within ".sign-up-button.top" do
          page.should have_selector("span", :text => "Start a Club Now")
        end
      end

      it "displays a learn more bottom button" do
        within ".sign-up-button.bottom" do
          page.should have_selector("span", :text => "Start a Club Now")
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

      it "displays a my club top button" do
        within ".sign-up-button.top" do
          page.should have_selector("span", :text => "My Club")
        end
      end

      it "displays a my club bottom button" do
        within ".sign-up-button.bottom" do
          page.should have_selector("span", :text => "My Club")
        end
      end
    end
  end
end
