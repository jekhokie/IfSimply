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
          page.should have_selector("div.user-club-label", :text => "My Club")
        end
      end

      it "shows the user's club name" do
        within ".user-clubs-listing .owned-clubs" do
          page.should have_selector("a", :text => user.clubs.first.name)
        end
      end

      it "shows the 'Memberships' label" do
        within ".user-clubs-listing .subscribed-clubs" do
          page.should have_selector("div.user-subscriptions-label", :text => "My Memberships")
        end
      end

      it "shows the user's memberships with the associated level and delete link" do
        user.subscriptions.each do |subscription|
          within ".user-clubs-listing .subscribed-clubs" do
            page.should have_selector("i.icon-remove")
            page.should have_selector(".subscription-level", :text => "(#{subscription.level.titleize})")
            page.should have_selector(".subscription-club-name a", :text => "#{subscription.club.name}")
          end
        end
      end
    end

    describe "for a User not belonging to the IfSimply Club" do
      let!(:other_user) { FactoryGirl.create :user }

      before :each do
        other_user.confirm!
        login_as other_user, :scope => :user

        visit user_path(other_user)
      end

      it "shows the label to subscribe to the IfSimply Club" do
        within ".user-clubs-listing .owned-clubs .ifsimply-club-visit" do
          page.should have_selector("a", :text => Club.find(1).name)
        end
      end
    end

    describe "for a User belonging to the IfSimply Club" do
      let!(:other_user)   { FactoryGirl.create :user }
      let!(:subscription) { FactoryGirl.create :subscription, :user  => other_user,
                                                              :club  => Club.find(1),
                                                              :level => 'basic' }

      before :each do
        other_user.confirm!
        login_as other_user, :scope => :user

        visit user_path(other_user)
      end

      it "does not show the label to subscribe to the IfSimply Club" do
        within ".user-clubs-listing .owned-clubs" do
          page.should_not have_selector(".ifsimply-club-visit")
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
          page.should have_selector("div.user-club-label", :text => "User's Club")
        end
      end

      it "shows the user's club name" do
        within ".user-clubs-listing .owned-clubs" do
          page.should have_selector("a", :text => user.clubs.first.name)
        end
      end

      it "shows the 'Memberships' label" do
        within ".user-clubs-listing .subscribed-clubs" do
          page.should have_selector("div.user-subscriptions-label", :text => "User's Memberships")
        end
      end

      it "shows the user's memberships without the associated level or delete link" do
        user.subscriptions.each do |subscription|
          within ".user-clubs-listing .subscribed-clubs" do
            page.should_not have_selector("i.icon-remove")
            page.should_not have_selector(".subscription-level", :text => "(#{subscription.level.titleize})")
            page.should have_selector("a", :text => "#{subscription.club.name} #{subscription.club.sub_heading}")
          end
        end
      end
    end
  end
end
