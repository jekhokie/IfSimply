require 'spec_helper'

describe "clubs_users/new.html.erb" do
  include Warden::Test::Helpers
  Warden.test_mode!

  describe "GET 'new'" do
    let!(:club) { FactoryGirl.create :club }

    describe "for a non-subscribed user" do
      let!(:user) { FactoryGirl.create :user }

      before :each do
        user.confirm!
        login_as user, :scope => :user

        visit subscribe_to_club_path(club)
      end

      it "does not contain an upgrade message" do
        within "div.club-subscription-information" do
          page.should_not have_selector(".upgrade-heading")
        end
      end
    end

    describe "for a basic-subscribed user" do
      let!(:basic_user)         { FactoryGirl.create :user }
      let!(:basic_subscription) { FactoryGirl.create :subscription, :user => basic_user, :club => club, :level => 'basic' }

      before :each do
        basic_user.confirm!
        login_as basic_user, :scope => :user

        visit subscribe_to_club_path(club)
      end

      it "contains an upgrade message" do
        within "div.club-subscription-information" do
          page.should have_selector(".upgrade-heading")
        end
      end

      it "contains a disabled 'Basic' button with the text 'Subscribed'" do
        within "tr.subscription-type" do
          page.should have_css("input[value=\"Subscribed\"]")
        end
      end

      it "contains a 'Pro' button with the text 'Pro'" do
        within "tr.subscription-type" do
          page.should have_css("input[value=\"Pro\"]")
        end
      end
    end

    describe "for a pro-subscribed user" do
      let!(:pro_user)         { FactoryGirl.create :user }
      let!(:pro_subscription) { FactoryGirl.create :subscription, :user => pro_user, :club => club, :level => 'pro', :pro_status => "ACTIVE" }

      before :each do
        pro_user.confirm!
        login_as pro_user, :scope => :user

        visit subscribe_to_club_path(club)
      end

      it "does not contain an upgrade message" do
        within "div.club-subscription-information" do
          page.should_not have_selector(".upgrade-heading")
        end
      end

      it "contains a 'Basic' button with the text 'Basic'" do
        within "tr.subscription-type" do
          page.should have_css("input[value=\"Basic\"]")
        end
      end

      it "contains a 'Pro' button with the text 'Subscribed'" do
        within "tr.subscription-type" do
          page.should have_css("input[value=\"Subscribed\"]")
        end
      end
    end
  end
end
