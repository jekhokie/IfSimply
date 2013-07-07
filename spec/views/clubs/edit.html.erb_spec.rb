require 'spec_helper'

describe "clubs/edit.html.erb" do
  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { FactoryGirl.create :user }

  describe "GET 'edit'" do
    describe "for a club owner" do
      before :each do
        user = FactoryGirl.create :user
        user.confirm!
        login_as user, :scope => :user

        visit edit_club_path(user.clubs.first)
      end

      it "displays a 'Change Image' button" do
        within ".club-avatar" do
          page.should have_selector("a", :text => "Change Image")
        end
      end
    end
  end
end
