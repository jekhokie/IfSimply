require 'spec_helper'

describe "topics/new.html.erb" do
  include Warden::Test::Helpers
  Warden.test_mode!

  let!(:user) { FactoryGirl.create :user }
  let!(:club) { user.clubs.first }

  describe "GET 'new'" do
    describe "for a club owner" do
      before :each do
        user.confirm!
        login_as user, :scope => :user

        visit new_discussion_board_topic_path(club.discussion_board)
      end

      it "displays a 'Cancel' button" do
        within "form.create-topic" do
          page.should have_selector("a.cancel-topic-create", :text => "Cancel")
        end
      end
    end
  end
end
