require 'spec_helper'

describe "home/learn_more.html.erb" do
  include Warden::Test::Helpers
  Warden.test_mode!

  describe "GET 'edit_club'" do
    describe "for a user with only a first name" do
      let(:user) { FactoryGirl.create :user, :name => "John" }

      before :each do
        user.confirm!
        login_as user, :scope => :user

        visit edit_club_path(user.clubs.first)
      end

      it "displays welcome with the user's first name" do
        within ".welcome-navigation .welcome-container" do
          page.should have_selector("span.welcome-text", :text => "Hi, John!")
        end
      end
    end

    describe "for a user with a first and last name" do
      let(:user) { FactoryGirl.create :user, :name => "John Doe" }

      before :each do
        user.confirm!
        login_as user, :scope => :user

        visit edit_club_path(user.clubs.first)
      end

      it "displays welcome with the user's first name" do
        within ".welcome-navigation .welcome-container" do
          page.should have_selector("span.welcome-text", :text => "Hi, John!")
        end
      end
    end

    describe "for a user with multiple name components" do
      let(:user) { FactoryGirl.create :user, :name => "John Someone Else Doe" }

      before :each do
        user.confirm!
        login_as user, :scope => :user

        visit edit_club_path(user.clubs.first)
      end

      it "displays welcome with the user's first name" do
        within ".welcome-navigation .welcome-container" do
          page.should have_selector("span.welcome-text", :text => "Hi, John!")
        end
      end
    end
  end
end
