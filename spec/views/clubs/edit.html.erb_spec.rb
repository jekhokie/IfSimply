require 'spec_helper'

describe "clubs/edit.html.erb" do
  include Warden::Test::Helpers
  Warden.test_mode!

  let!(:user)   { FactoryGirl.create :user }
  let!(:club)   { user.clubs.first }
  let!(:course) { FactoryGirl.create :course, :club => club }

  describe "GET 'edit'" do
    describe "for a club owner" do
      before :each do
        user.confirm!
        login_as user, :scope => :user

        visit edit_club_path(club)
      end

      it "displays a 'Change Image' button" do
        within ".club-avatar" do
          page.should have_selector("a", :text => "Change Image")
        end
      end

      describe "courses" do
        it "displays a course image" do
          within ".course-logo" do
            page.should have_selector(".course-image-link")
          end
        end
      end
    end
  end
end
