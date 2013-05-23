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

  describe "PUT 'update'" do
    let(:discussion_board) { FactoryGirl.create :discussion_board, :club_id => user.clubs.first.id }
    let(:new_name)         { "Test Discussion Board" }

    describe "for valid attributes" do
      before :each do
        put 'update', :id => discussion_board.id, :discussion_board => { :name => new_name }
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the course" do
        assigns(:discussion_board).should_not be_nil
      end

      it "assigns the new attributes" do
        discussion_board.reload
        discussion_board.name.should == new_name
      end
    end

    describe "for invalid attributes" do
      before :each do
        @old_name = discussion_board.name
        put 'update', :id => discussion_board.id, :discussion_board => { :name => "" }
      end

      it "returns http unprocessable" do
        response.response_code.should == 422
      end

      it "returns the discussion_board" do
        assigns(:discussion_board).should == discussion_board
      end

      it "does not update the attributes" do
        discussion_board.reload
        discussion_board.name.should == @old_name
      end
    end
  end
end
