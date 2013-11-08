require 'spec_helper'

describe SalesPagesController do
  describe "GET 'show'" do
    let!(:club)       { FactoryGirl.create :club }
    let!(:sales_page) { club.sales_page }

    before :each do
      get 'show', :club_id => sales_page.club.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the club" do
      assigns(:club).should == sales_page.club
    end

    it "returns the sales_page" do
      assigns(:sales_page).should == sales_page
    end
  end

  describe "GET 'edit'" do
    let!(:user)       { FactoryGirl.create :user }
    let!(:sales_page) { user.clubs.first.sales_page }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    before :each do
      get "edit", :club_id => sales_page.club.id
    end

    it "returns http success" do
      response.should be_success
    end

    it "returns the club" do
      assigns(:club).should == sales_page.club
    end

    it "returns the sales_page" do
      assigns(:sales_page).should == sales_page
    end

    it "renders the mercury layout" do
      response.should render_template(:layout => "layouts/mercury")
    end
  end

  describe "PUT 'update'" do
    let!(:user)        { FactoryGirl.create :user }
    let!(:sales_page)  { user.clubs.first.sales_page }
    let!(:new_heading) { "Test Heading" }

    before :each do
      FakeWeb.clean_registry
      FakeWeb.register_uri(:head, "http://www.ifsimply.com/", :body => "", :status => [ "200", "OK" ])

      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    describe "for valid attributes" do
      before :each do
        put 'update', :club_id => sales_page.club.id, :content => { :sales_page_heading        => { :value => new_heading },
                                                                    :sales_page_sub_heading    => { :value => "abc" },
                                                                    :sales_page_call_to_action => { :value => "123" },
                                                                    :club_price                => { :value => "10.00" },
                                                                    :sales_page_video_url      => { :value => "http://www.ifsimply.com/" },
                                                                    :sales_page_benefit1       => { :value => "abc" },
                                                                    :sales_page_benefit2       => { :value => "abc" },
                                                                    :sales_page_benefit3       => { :value => "abc" },
                                                                    :sales_page_details        => { :value => "test" } }
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end

      it "returns the sales_page" do
        assigns(:sales_page).should == sales_page
      end

      it "assigns the new attributes" do
        sales_page.reload
        sales_page.heading.should == new_heading
      end

      it "renders blank text as a response" do
        response.body.should == ""
      end
    end

    describe "for invalid sales_page attributes" do
      before :each do
        @old_heading = sales_page.heading
        put 'update', :club_id => sales_page.club.id, :content => { :sales_page_heading        => { :value => "" },
                                                                    :sales_page_sub_heading    => { :value => "abc" },
                                                                    :sales_page_call_to_action => { :value => "123" },
                                                                    :club_price                => { :value => "10.00" },
                                                                    :sales_page_video_url      => { :value => "http://www.ifsimply.com/" },
                                                                    :sales_page_benefit1       => { :value => "abc" },
                                                                    :sales_page_benefit2       => { :value => "abc" },
                                                                    :sales_page_benefit3       => { :value => "abc" } }
      end

      it "returns http unprocessable" do
        response.response_code.should == 422
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end

      it "returns the sales_page" do
        assigns(:sales_page).should == sales_page
      end

      it "does not update the attributes" do
        sales_page.reload
        sales_page.heading.should == @old_heading
      end

      it "returns error about invalid sales_page attributes" do
        response.headers["X-Flash-Error"].should == "Heading for sales page can't be blank"
      end

      it "renders error text as a response" do
        response.body.should == "error"
      end
    end

    describe "for invalid club attributes" do
      before :each do
        @old_price = sales_page.club.price
        put 'update', :club_id => sales_page.club.id, :content => { :sales_page_heading        => { :value => "abc" },
                                                                    :sales_page_sub_heading    => { :value => "abc" },
                                                                    :sales_page_call_to_action => { :value => "123" },
                                                                    :club_price                => { :value => "1" },
                                                                    :sales_page_video_url      => { :value => "http://www.ifsimply.com/" },
                                                                    :sales_page_benefit1       => { :value => "abc" },
                                                                    :sales_page_benefit2       => { :value => "abc" },
                                                                    :sales_page_benefit3       => { :value => "abc" } }
      end

      it "returns http unprocessable" do
        response.response_code.should == 422
      end

      it "returns the club" do
        assigns(:club).should_not be_nil
      end

      it "returns the sales_page" do
        assigns(:sales_page).should == sales_page
      end

      it "does not update the attributes" do
        sales_page.reload
        sales_page.club.price.should == @old_price
      end

      it "returns error about invalid sales_page attributes" do
        response.headers["X-Flash-Error"].should == "Price cents must be at least $10"
      end

      it "renders error text as a response" do
        response.body.should == "error"
      end
    end
  end
end
