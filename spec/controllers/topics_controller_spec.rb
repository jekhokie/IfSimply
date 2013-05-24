require 'spec_helper'

describe TopicsController do
  let(:user) { FactoryGirl.create :user }

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:users]
    sign_in user
  end

  describe "GET 'new'" do
    let(:discussion_board) { FactoryGirl.create :discussion_board, :club_id => user.clubs.first.id }

    before :each do
      get 'new', :discussion_board_id => discussion_board.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the discussion_board" do
      assigns(:discussion_board).should == discussion_board
    end

    it "returns a new unsaved topic" do
      assigns(:topic).should be_new_record
    end
  end

  describe "POST 'create'" do
    let(:discussion_board) { FactoryGirl.create :discussion_board, :club_id => user.clubs.first.id }
    let(:new_subject)      { "Test Topic" }

    it "updates the topic count" do
      lambda{ post('create', :discussion_board_id => discussion_board.id, :topic => { :subject => new_subject, :description => "Test description" }) }.should
        change(discussion_board.topics, :count).by(+1)
    end

    describe "for valid attributes" do
      before :each do
        post 'create', :discussion_board_id => discussion_board.id, :topic => { :subject => new_subject, :description => "Test description" }
      end

      it "returns http redirect" do
        response.should be_redirect
      end

      it "redirects to the discussion_board path" do
        response.should redirect_to(edit_discussion_board_path(discussion_board))
      end

      it "returns the discussion_board" do
        assigns(:discussion_board).should == discussion_board
      end
    end

    describe "for invalid attributes" do
      before :each do
        post 'create', :discussion_board_id => discussion_board.id, :topic => { :subject => "" }
      end

      it "returns http success" do
        response.should be_success
      end

      it "renders the new action" do
        response.should render_template("topics/new")
      end

      it "returns the discussion_board" do
        assigns(:discussion_board).should == discussion_board
      end

      it "returns the topic with an error" do
        assigns(:topic).should_not be_blank
        assigns(:topic).errors.should_not be_blank
      end
    end
  end

  describe "GET 'show'" do
    let!(:discussion_board) { FactoryGirl.create :discussion_board, :club_id => user.clubs.first.id }
    let!(:topic)            { FactoryGirl.create :topic, :discussion_board_id => discussion_board.id }

    before :each do
      get 'show', :id => topic.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the topic" do
      assigns(:topic).should == topic
    end
  end
end
