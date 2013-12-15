require 'spec_helper'

describe "upsell_pages/show.html.erb" do
  include Warden::Test::Helpers
  Warden.test_mode!

  describe "GET 'new'" do
    let!(:club_user) { FactoryGirl.create :user, :verified => true }
    let!(:club)      { club_user.clubs.first }

    describe "for a non-subscribed user" do
      let!(:user) { FactoryGirl.create :user }

      before :each do
        user.confirm!
        login_as user, :scope => :user

        visit club_upsell_page_path(club)
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

        visit club_upsell_page_path(club)
      end

      it "contains a disabled 'Basic' button with the text 'SUBSCRIBED' in the header section" do
        within "table.club-subscription-information thead tr" do
          page.should have_css("a span:contains(\"SUBSCRIBED\")")
        end
      end

      it "contains a disabled 'Basic' button with the text 'SUBSCRIBED' in the footer section" do
        within "table.club-subscription-information tfoot tr" do
          page.should have_css("a span:contains(\"SUBSCRIBED\")")
        end
      end

      it "contains a 'Pro' button with the text 'FREE TRIAL' in the header section" do
        within "table.club-subscription-information thead tr" do
          page.should have_css("a span:contains(\"FREE TRIAL\")")
        end
      end

      it "contains a 'Pro' button with the text 'FREE TRIAL' in the footer section" do
        within "table.club-subscription-information tfoot tr" do
          page.should have_css("a span:contains(\"FREE TRIAL\")")
        end
      end
    end

    describe "for a pro-subscribed user" do
      let!(:pro_user)         { FactoryGirl.create :user }
      let!(:pro_subscription) { FactoryGirl.create :subscription, :user => pro_user, :club => club, :level => 'pro', :pro_status => "ACTIVE" }

      before :each do
        pro_user.confirm!
        login_as pro_user, :scope => :user

        visit club_upsell_page_path(club)
      end

      it "contains a 'Basic' button with the text 'BASIC ONLY' in the header section" do
        within "table.club-subscription-information thead tr" do
          page.should have_css("a span:contains(\"BASIC ONLY\")")
        end
      end

      it "contains a 'Basic' button with the text 'BASIC ONLY' in the footer section" do
        within "table.club-subscription-information tfoot tr" do
          page.should have_css("a span:contains(\"BASIC ONLY\")")
        end
      end

      it "contains a 'Pro' button with the text 'SUBSCRIBED' in the header section" do
        within "table.club-subscription-information thead tr" do
          page.should have_css("a span:contains(\"SUBSCRIBED\")")
        end
      end

      it "contains a 'Pro' button with the text 'SUBSCRIBED' in the footer section" do
        within "table.club-subscription-information tfoot tr" do
          page.should have_css("a span:contains(\"SUBSCRIBED\")")
        end
      end
    end
  end
end
