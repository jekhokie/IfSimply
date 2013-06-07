require 'spec_helper'

describe "home/learn_more.html.erb" do
  include Warden::Test::Helpers
  Warden.test_mode!

  describe "GET '/learn_more'" do
    describe "for a non signed-in guest" do
      before :each do
        visit '/learn_more'
      end

      it "should display a sign-up button" do
        within ".sign-up" do
          page.should have_selector('a.submit-sign-up')
        end
      end
    end
  end
end
