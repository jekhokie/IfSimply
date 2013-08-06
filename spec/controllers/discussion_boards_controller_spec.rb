require 'spec_helper'

describe DiscussionBoardsController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'show'" do
    let!(:club)             { user.clubs.first }
    let!(:discussion_board) { club.discussion_board }

    describe "for a signed-in user" do
      describe "for the club owner" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in user

          get 'show', :id => discussion_board.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the discussion_board show view" do
          response.should render_template("discussion_boards/show")
        end

        it "returns the discussion_board" do
          assigns(:discussion_board).should_not be_nil
        end

        it "returns the club" do
          assigns(:club).should_not be_nil
        end
      end

      describe "for a subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => club }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribed_user

          get 'show', :id => discussion_board.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the discussion_board show view" do
          response.should render_template("discussion_boards/show")
        end

        it "returns the discussion_board" do
          assigns(:discussion_board).should_not be_nil
        end

        it "returns the club" do
          assigns(:club).should_not be_nil
        end
      end

      describe "for a non-subscriber" do
        let!(:non_subscribed_user) { FactoryGirl.create :user }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in non_subscribed_user

          get 'show', :id => discussion_board.id
        end

        it "redirects to the sales page" do
          response.should redirect_to(club_sales_page_path(club))
        end

        it "returns the discussion_board" do
          assigns(:discussion_board).should_not be_nil
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'show', :id => discussion_board.id
      end

      it "redirects to the sales page" do
        response.should redirect_to(club_sales_page_path(club))
      end

      it "returns the discussion_board" do
        assigns(:discussion_board).should_not be_nil
      end
    end
  end

  describe "GET 'edit'" do
    let(:discussion_board) { FactoryGirl.create :discussion_board, :club_id => user.clubs.first.id }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user

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

    it "renders the mercury layout" do
      response.should render_template(:layout => "layouts/mercury")
    end
  end

  describe "PUT 'update'" do
    let(:discussion_board) { FactoryGirl.create :discussion_board, :club_id => user.clubs.first.id }
    let(:new_name)         { "Test Discussion Board" }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    describe "for valid attributes" do
      before :each do
        put 'update', :id => discussion_board.id, :content => { :discussion_board_name        => { :value => new_name },
                                                                :discussion_board_description => { :value => "abc" } }
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

      it "renders blank text as a response" do
        response.body.should == ""
      end
    end

    describe "for invalid attributes" do
      before :each do
        @old_name = discussion_board.name
        put 'update', :id => discussion_board.id, :content => { :discussion_board_name        => { :value => "" },
                                                                :discussion_board_description => { :value => "abc" } }
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

      it "returns error about invalid attributes" do
        response.headers["X-Flash-Error"].should == "Name for discussion board can't be blank"
      end

      it "renders error text as a response" do
        response.body.should == "error"
      end
    end
  end
end
