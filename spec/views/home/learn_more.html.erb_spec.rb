require 'spec_helper'

describe "home/learn_more.html.erb" do
  include Warden::Test::Helpers
  Warden.test_mode!

  describe "GET '/learn_more'" do
    describe "for a signed-in user" do
      before :each do
        login_as FactoryGirl.create(:user), :scope => :user
        visit '/learn_more'
      end

      after :each do
        Warden.test_reset!
      end

      it "should display a link to the user's club" do
        within ".sign-up-form" do
          page.should have_selector('a', :text => 'Go to My Club')
        end
      end
    end

    describe "for a non signed-in guest" do
      before :each do
        visit '/learn_more'
      end

      it "should display a sign-up form with required elements" do
        within ".sign-up-form" do
          page.should have_selector('input#user_name.required')
          page.should have_selector('input#user_email.required')
          page.should have_selector('input#user_password.required')
          page.should have_selector('input#user_password_confirmation.required')
        end
      end
    end
  end
end
