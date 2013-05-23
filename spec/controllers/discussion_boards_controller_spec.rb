require 'spec_helper'

describe DiscussionBoardsController do
  let(:user) { FactoryGirl.create :user }

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:users]
    sign_in user
  end

  describe "GET 'edit'" do
    let(:discussion_board) { FactoryGirl.create :discussion_board, :club_id => user.clubs.first.id }

    before :each do
      get 'edit', :id => discussion_board.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the club" do
      assigns(:club).should == discussion_board.club
    end

    it "returns the blog" do
      assigns(:discussion_board).should == discussion_board
    end
  end
end
