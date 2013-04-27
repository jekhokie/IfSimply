require 'spec_helper'

describe "home/index.html.erb" do
  include Warden::Test::Helpers
  Warden.test_mode!

  describe "GET '/'" do
    describe "for a signed-in user" do
      before :each do
        login_as FactoryGirl.create(:user), :scope => :user
        visit '/'
      end

      after :each do
        Warden.test_reset!
      end

      it "should display a link to the user's club" do
        page.should have_selector('a span', :text => 'My Club')
      end

      describe "navbar" do
        it "should display a link to the user's account" do
          within ".navbar" do
            page.should have_selector('a', :text => 'Account')
          end
        end

        it "should display a link to Logout" do
          within ".navbar" do
            page.should have_selector('a', :text => 'Logout')
          end
        end
      end
    end

    describe "for a non signed-in guest" do
      before :each do
        visit '/'
      end

      it "should display a 'Learn More' link" do
        page.should have_selector('a span', :text => 'Learn More')
      end

      it "should display a link to Login" do
        within ".navbar" do
          page.should have_selector('a', :text => 'Login')
        end
      end
    end
  end
end
