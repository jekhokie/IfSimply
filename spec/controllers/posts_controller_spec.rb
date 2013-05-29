require 'spec_helper'

describe PostsController do
  let(:user) { FactoryGirl.create :user }

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:users]
    sign_in user
  end

  describe "GET 'new'" do
    let(:discussion_board) { FactoryGirl.create :discussion_board, :club_id => user.clubs.first.id }
    let(:topic)            { FactoryGirl.create :topic, :discussion_board_id => discussion_board.id }

    before :each do
      get 'new', :topic_id => topic.id, :format => 'js'
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the topic" do
      assigns(:topic).should == topic
    end

    it "returns a new unsaved post" do
      assigns(:post).should be_new_record
    end
  end

  describe "POST 'create'" do
    let(:discussion_board) { FactoryGirl.create :discussion_board, :club_id => user.clubs.first.id }
    let(:topic)            { FactoryGirl.create :topic, :discussion_board_id => discussion_board.id }
    let(:new_content)      { "Test Post Content" }

    it "updates the post count" do
      lambda{ post('create', :topic_id => topic.id, :post => { :content => new_content }, :format => 'js') }.should change(topic.posts, :count).by(+1)
    end

    describe "for valid attributes" do
      before :each do
        post 'create', :topic_id => topic.id, :post => { :content => new_content }, :format => 'js'
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the topic" do
        assigns(:topic).should == topic
      end

      it "returns the post" do
        assigns(:post).should_not be_blank
      end

      it "assigns the post to the user" do
        assigns(:post).user_id.should == user.id
      end

      it "returns the posts" do
        assigns(:posts).should_not be_blank
      end

      it "includes the new post information" do
        assigns(:posts).map(&:content).should include(new_content)
      end
    end

    describe "for invalid attributes" do
      before :each do
        post 'create', :topic_id => topic.id, :post => { :content => "" }, :format => 'js'
      end

      it "returns http success" do
        response.should be_success
      end

      it "renders the new action" do
        response.should render_template("posts/new")
      end

      it "returns the topic" do
        assigns(:topic).should == topic
      end

      it "returns the post with an error" do
        assigns(:post).should_not be_blank
        assigns(:post).errors.should_not be_blank
      end
    end
  end
end
