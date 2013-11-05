require 'spec_helper'

describe "users/show.html.erb" do
  include Warden::Test::Helpers
  Warden.test_mode!

  let!(:user)               { FactoryGirl.create :user }
  let!(:club_1)             { FactoryGirl.create :club }
  let!(:club_2)             { FactoryGirl.create :club }
  let!(:basic_subscription) { FactoryGirl.create :subscription, :user => user, :club => club_1, :level => 'basic' }
  let!(:pro_subscription)   { FactoryGirl.create :subscription, :user => user, :club => club_2, :level => 'pro', :pro_status => 'ACTIVE' }

  describe "GET 'show'" do
    describe "for the current user" do
      before :each do
        user.confirm!
        login_as user, :scope => :user

        visit user_path(user)
      end

      it "shows the 'Your Club' label" do
        within ".user-clubs-listing .owned-clubs" do
          page.should have_selector("div.clubs-label", :text => "Your Club:")
        end
      end

      it "shows the user's club name" do
        within ".user-clubs-listing .owned-clubs" do
          page.should have_selector("a", :text => user.clubs.first.name)
        end
      end

      it "shows the 'Memberships' label" do
        within ".user-clubs-listing .subscribed-clubs" do
          page.should have_selector("div.clubs-label", :text => "Memberships:")
        end
      end

      it "shows the user's memberships with the associated level" do
        user.subscriptions.each do |subscription|
          within ".user-clubs-listing .subscribed-clubs" do
            page.should have_selector("a", :text => "(#{subscription.level.titleize}) #{subscription.club.name} #{subscription.club.sub_heading}")
          end
        end
      end
    end

    describe "for a different user" do
      let!(:visitor) { FactoryGirl.create :user }

      before :each do
        visitor.confirm!
        login_as visitor, :scope => :user

        visit user_path(user)
      end

      it "shows the 'User's Club' label" do
        within ".user-clubs-listing .owned-clubs" do
          page.should have_selector("div.clubs-label", :text => "User's Club:")
        end
      end

      it "shows the user's club name" do
        within ".user-clubs-listing .owned-clubs" do
          page.should have_selector("a", :text => user.clubs.first.name)
        end
      end

      it "shows the 'Memberships' label" do
        within ".user-clubs-listing .subscribed-clubs" do
          page.should have_selector("div.clubs-label", :text => "Memberships:")
        end
      end

      it "shows the user's memberships without the associated level" do
        user.subscriptions.each do |subscription|
          within ".user-clubs-listing .subscribed-clubs" do
            page.should have_selector("a", :text => "#{subscription.club.name} #{subscription.club.sub_heading}")
          end
        end
      end
    end
  end
end
