require 'spec_helper'

describe HomeController do
  describe "GET 'index'" do
    it "is successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'registration_notify'" do
    it "is successful" do
      get 'registration_notify'
      response.should be_success
    end
  end

  describe "GET 'access_violation'" do
    let(:exception_message) { "Custom Exception" }

    before :each do
      get 'access_violation', :exception => exception_message
    end

    it "is successful" do
      response.should be_success
    end

    it "assigns violation" do
      assigns(:violation).should == exception_message
    end
  end

  describe "GET 'terms_and_conditions'" do
    it "is successful" do
      get 'terms_and_conditions'
      response.should be_success
    end
  end

  describe "GET 'privacy_policy'" do
    it "is successful" do
      get 'privacy_policy'
      response.should be_success
    end
  end

  describe "GET 'dmca_policy'" do
    it "is successful" do
      get 'dmca_policy'
      response.should be_success
    end
  end

  describe "GET 'faq'" do
    it "is successful" do
      get 'faq'
      response.should be_success
    end
  end

  describe "GET 'free_ebook'" do
    describe "for a missing keycode" do
      it "redirects to the index page" do
        get 'free_ebook'
        response.should redirect_to(root_path)
      end
    end

    describe "for a valid keycode" do
      it "is successful" do
        get 'free_ebook', :keycode => "p4R3-sabpXq5zVxkAhaN-_NLFSo3fHwQ8ONdmWKkndKRB4JAFfeIATEnlbKUawqJjZIoqLPRNTxhsskNFvYLhQ"
        response.should be_success
      end
    end

    describe "for an invalid keycode" do
      it "redirects to the index page" do
        get 'free_ebook', :keycode => "OIEHG()YE*()YH#*H)W#HG)#HG"
        response.should redirect_to(root_path)
      end
    end
  end
end
