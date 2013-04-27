require 'spec_helper'

describe HomeController do
  describe "GET 'index'" do
    it "is successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'learn_more'" do
    it "is successful" do
      get 'learn_more'
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
end
