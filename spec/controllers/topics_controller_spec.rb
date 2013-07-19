require 'spec_helper'

describe TopicsController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'show'" do
    let!(:club)             { user.clubs.first }
    let!(:discussion_board) { club.discussion_board }
    let!(:topic)            { FactoryGirl.create :topic, :discussion_board => discussion_board }

    describe "for a signed-in user" do
      describe "for the club owner" do
        let!(:owned_topic) { FactoryGirl.create :topic, :discussion_board => club.discussion_board }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in user

          get 'show', :id => owned_topic.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the topic show view" do
          response.should render_template("topics/show")
        end

        it "returns the topic" do
          assigns(:topic).should_not be_nil
        end
      end

      describe "for a subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => club }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribed_user

          get 'show', :id => topic.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the topic show view" do
          response.should render_template("topics/show")
        end

        it "returns the topic" do
          assigns(:topic).should_not be_nil
        end
      end

      describe "for a non-subscriber" do
        let!(:non_subscribed_user) { FactoryGirl.create :user }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in non_subscribed_user

          get 'show', :id => topic.id
        end

        it "redirects to the sales page" do
          response.should redirect_to(club_sales_page_path(club))
        end

        it "returns the topic" do
          assigns(:topic).should_not be_nil
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'show', :id => topic.id
      end

      it "redirects to the sales page" do
        response.should redirect_to(club_sales_page_path(club))
      end

      it "returns the topic" do
        assigns(:topic).should_not be_nil
      end
    end
  end

  describe "GET 'new'" do
    let(:discussion_board) { FactoryGirl.create :discussion_board, :club_id => user.clubs.first.id }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user

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
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user

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
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user

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
end
