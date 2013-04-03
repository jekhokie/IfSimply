require 'spec_helper'

describe HomeController do
  describe "GET 'index'" do
    it 'should be successful' do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'learn_more'" do
    it 'should be successful' do
      get 'learn_more'
      response.should be_success
    end
  end
end
