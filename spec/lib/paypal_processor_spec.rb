require 'spec_helper'

describe "PaypalProcessor lib" do
  describe ".is_verified?(paypal_email)" do
    it "returns true for a verified email address" do
      email_address = "verified@test.com"

      api = PayPal::SDK::AdaptiveAccounts::API.new
      PayPal::SDK::AdaptiveAccounts::API.should_receive(:new).and_return api

      verifier = PayPal::SDK::AdaptiveAccounts::DataTypes::GetVerifiedStatusRequest.new :email_address => email_address,
                                                                                        :match_criteria => "NONE"
      api.should_receive(:build_get_verified_status).and_return verifier

      verified_response = PayPal::SDK::AdaptiveAccounts::DataTypes::GetVerifiedStatusResponse.new :account_status    => "VERIFIED",
                                                                                                  :response_envelope => { :ack => "Success" }
      api.should_receive(:get_verified_status).with(verifier).and_return verified_response

      PaypalProcessor.is_verified?(email_address).should == true
    end

    it "returns false for a non-verified email address" do
      email_address = "unverified@test.com"

      api = PayPal::SDK::AdaptiveAccounts::API.new
      PayPal::SDK::AdaptiveAccounts::API.should_receive(:new).and_return api

      verifier = PayPal::SDK::AdaptiveAccounts::DataTypes::GetVerifiedStatusRequest.new :email_address => email_address,
                                                                                        :match_criteria => "NONE"
      api.should_receive(:build_get_verified_status).and_return verifier

      verified_response = PayPal::SDK::AdaptiveAccounts::DataTypes::GetVerifiedStatusResponse.new :account_status    => "UNVERIFIED",
                                                                                                  :response_envelope => { :ack => "Success" }
      api.should_receive(:get_verified_status).with(verifier).and_return verified_response

      PaypalProcessor.is_verified?(email_address).should == false
    end

    it "returns false for an invalid response from PayPal" do
      email_address = "verified@test.com"

      api = PayPal::SDK::AdaptiveAccounts::API.new
      PayPal::SDK::AdaptiveAccounts::API.should_receive(:new).and_return api

      verifier = PayPal::SDK::AdaptiveAccounts::DataTypes::GetVerifiedStatusRequest.new :email_address => email_address,
                                                                                        :match_criteria => "NONE"
      api.should_receive(:build_get_verified_status).and_return verifier

      verified_response = PayPal::SDK::AdaptiveAccounts::DataTypes::GetVerifiedStatusResponse.new :account_status    => "UNVERIFIED",
                                                                                                  :response_envelope => { :ack => "Failure" }
      api.should_receive(:get_verified_status).with(verifier).and_return verified_response

      PaypalProcessor.is_verified?(email_address).should == false
    end

    it "returns false for a blank email address" do
      PaypalProcessor.is_verified?("").should == false
    end

    it "returns false for a malformed email address" do
      PaypalProcessor.is_verified?("blah").should == false
    end
  end
end
