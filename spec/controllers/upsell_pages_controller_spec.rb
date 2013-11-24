require 'spec_helper'

describe UpsellPagesController do
  describe "GET 'show'" do
    describe "for a Club owner with a verified PayPal account" do
      let!(:user)        { FactoryGirl.create :user, :verified => true }
      let!(:club)        { FactoryGirl.create :club, :user => user }
      let!(:upsell_page) { club.upsell_page }

      before :each do
        get 'show', :club_id => upsell_page.club.id
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the club" do
        assigns(:club).should == upsell_page.club
      end

      it "returns the upsell_page" do
        assigns(:upsell_page).should == upsell_page
      end
    end

    describe "for a Club owner with an unverified PayPal account" do
      let!(:user)        { FactoryGirl.create :user, :verified => false }
      let!(:club)        { FactoryGirl.create :club, :user => user }
      let!(:upsell_page) { club.upsell_page }

      before :each do
        get 'show', :club_id => upsell_page.club.id
      end

      it "redirects to the root path" do
        response.should redirect_to(root_path)
      end

      it "returns the club" do
        assigns(:club).should == upsell_page.club
      end

      it "returns the upsell_page" do
        assigns(:upsell_page).should == upsell_page
      end

      it "returns a flash error" do
        flash[:error].should_not be_blank
      end
    end
  end

  describe "GET 'edit'" do
    let!(:user)        { FactoryGirl.create :user }
    let!(:upsell_page) { user.clubs.first.upsell_page }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    before :each do
      get "edit", :club_id => upsell_page.club.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the club" do
      assigns(:club).should == upsell_page.club
    end

    it "returns the upsell_page" do
      assigns(:upsell_page).should == upsell_page
    end

    it "renders the mercury layout" do
      response.should render_template(:layout => "layouts/mercury")
    end
  end

  describe "PUT 'update'" do
    let!(:user)        { FactoryGirl.create :user }
    let!(:upsell_page) { user.clubs.first.upsell_page }
    let!(:new_heading) { "Test Heading" }

    before :each do
      FakeWeb.clean_registry
      FakeWeb.register_uri(:head, "http://www.ifsimply.com/", :body => "", :status => [ "200", "OK" ])

      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    describe "for valid attributes" do
      before :each do
        put 'update', :club_id => upsell_page.club.id,
                      :content => { :upsell_page_heading                 => { :value => new_heading },
                                    :upsell_page_sub_heading             => { :value => "abc" },
                                    :club_price                          => { :value => "10.00" },
                                    :upsell_page_basic_articles_desc     => { :value => "http://www.ifsimply.com/" },
                                    :upsell_page_exclusive_articles_desc => { :value => "abc" },
                                    :upsell_page_basic_courses_desc      => { :value => "abc" },
                                    :upsell_page_in_depth_courses_desc   => { :value => "abc" },
                                    :upsell_page_discussion_forums_desc  => { :value => "test" } }
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end

      it "returns the upsell_page" do
        assigns(:upsell_page).should == upsell_page
      end

      it "assigns the new attributes" do
        upsell_page.reload
        upsell_page.heading.should == new_heading
      end

      it "renders blank text as a response" do
        response.body.should == ""
      end
    end

    describe "for invalid upsell_page attributes" do
      before :each do
        @old_heading = upsell_page.heading
        put 'update', :club_id => upsell_page.club.id,
                      :content => { :upsell_page_heading                 => { :value => "" },
                                    :upsell_page_sub_heading             => { :value => "abc" },
                                    :club_price                          => { :value => "10.00" },
                                    :upsell_page_basic_articles_desc     => { :value => "http://www.ifsimply.com/" },
                                    :upsell_page_exclusive_articles_desc => { :value => "abc" },
                                    :upsell_page_basic_courses_desc      => { :value => "abc" },
                                    :upsell_page_in_depth_courses_desc   => { :value => "abc" },
                                    :upsell_page_discussion_forums_desc  => { :value => "test" } }
      end

      it "returns http unprocessable" do
        response.response_code.should == 422
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end

      it "returns the upsell_page" do
        assigns(:upsell_page).should == upsell_page
      end

      it "does not update the attributes" do
        upsell_page.reload
        upsell_page.heading.should == @old_heading
      end

      it "returns error about invalid upsell_page attributes" do
        response.headers["X-Flash-Error"].should == "Heading for upsell page can't be blank"
      end

      it "renders error text as a response" do
        response.body.should == "error"
      end
    end

    describe "for invalid club attributes" do
      before :each do
        @old_price = upsell_page.club.price
        put 'update', :club_id => upsell_page.club.id,
                      :content => { :upsell_page_heading                 => { :value => "adf" },
                                    :upsell_page_sub_heading             => { :value => "abc" },
                                    :club_price                          => { :value => "1" },
                                    :upsell_page_basic_articles_desc     => { :value => "http://www.ifsimply.com/" },
                                    :upsell_page_exclusive_articles_desc => { :value => "abc" },
                                    :upsell_page_basic_courses_desc      => { :value => "abc" },
                                    :upsell_page_in_depth_courses_desc   => { :value => "abc" },
                                    :upsell_page_discussion_forums_desc  => { :value => "test" } }
      end

      it "returns http unprocessable" do
        response.response_code.should == 422
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end

      it "returns the upsell_page" do
        assigns(:upsell_page).should == upsell_page
      end

      it "does not update the attributes" do
        upsell_page.reload
        upsell_page.club.price.should == @old_price
      end

      it "returns error about invalid upsell_page attributes" do
        response.headers["X-Flash-Error"].should == "Price cents must be at least $10"
      end

      it "renders error text as a response" do
        response.body.should == "error"
      end
    end
  end
end
