require 'spec_helper'

describe DiscussionBoardsController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'show'" do
    let!(:club)             { FactoryGirl.create :club }
    let!(:discussion_board) { club.discussion_board }

    describe "for a signed-in user" do
      describe "for the club owner" do
        let!(:club_owner)             { FactoryGirl.create :user }
        let!(:club)                   { club_owner.clubs.first }
        let!(:owned_discussion_board) { club.discussion_board }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in club_owner

          get 'show', :id => owned_discussion_board.id
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
  end

  describe "PUT 'update'" do
    let(:discussion_board) { FactoryGirl.create :discussion_board, :club_id => user.clubs.first.id }
    let(:new_name)         { "Test Discussion Board" }

    describe "for valid attributes" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user

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
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user

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
