require 'spec_helper'

describe "PaypalProcessor lib" do
  describe ".is_verified?(paypal_email)" do
    it "returns false for a blank email address" do
      PaypalProcessor.is_verified?("").should == false
    end

    it "returns false for a malformed email address" do
      PaypalProcessor.is_verified?("blah").should == false
    end

    it "returns true for a verified email address" do
      email_address = "verified@test.com"

      api = PayPal::SDK::AdaptiveAccounts::API.new
      PayPal::SDK::AdaptiveAccounts::API.should_receive(:new).and_return api

      verifier = PayPal::SDK::AdaptiveAccounts::DataTypes::GetVerifiedStatusRequest.new :emailAddress => email_address,
                                                                                        :matchCriteria => "NONE"
      api.should_receive(:build_get_verified_status).and_return verifier

      verified_response = PayPal::SDK::AdaptiveAccounts::DataTypes::GetVerifiedStatusResponse.new :accountStatus    => "VERIFIED",
                                                                                                  :responseEnvelope => { :ack => "Success" }
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

      verified_response = PayPal::SDK::AdaptiveAccounts::DataTypes::GetVerifiedStatusResponse.new :accountStatus    => "UNVERIFIED",
                                                                                                  :responseEnvelope => { :ack => "Success" }
      api.should_receive(:get_verified_status).with(verifier).and_return verified_response

      PaypalProcessor.is_verified?(email_address).should == false
    end

    it "returns false for an invalid response from PayPal" do
      email_address = "verified@test.com"

      api = PayPal::SDK::AdaptiveAccounts::API.new
      PayPal::SDK::AdaptiveAccounts::API.should_receive(:new).and_return api

      verifier = PayPal::SDK::AdaptiveAccounts::DataTypes::GetVerifiedStatusRequest.new :emailAddress => email_address,
                                                                                        :matchCriteria => "NONE"
      api.should_receive(:build_get_verified_status).and_return verifier

      verified_response = PayPal::SDK::AdaptiveAccounts::DataTypes::GetVerifiedStatusResponse.new :accountStatus    => "UNVERIFIED",
                                                                                                  :responseEnvelope => { :ack => "Failure" }
      api.should_receive(:get_verified_status).with(verifier).and_return verified_response

      PaypalProcessor.is_verified?(email_address).should == false
    end
  end

  describe ".request_preapproval(monthly_amount, cancel_url, return_url, member_name, club_name)" do
    let!(:club)       { FactoryGirl.create :club }
    let!(:member)     { FactoryGirl.create :user }
    let!(:cancel_url) { Faker::Lorem.words(2).join " " }
    let!(:return_url) { Faker::Lorem.words(2).join " " }

    it "returns a blank hash for a blank monthly_amount" do
      PaypalProcessor.request_preapproval("", cancel_url, return_url, member.name, club.name, Date.today).should == {}
    end

    it "returns a blank hash for a blank cancel_url" do
      PaypalProcessor.request_preapproval(club.price, "", return_url, member.name, club.name, Date.today).should == {}
    end

    it "returns a blank hash for a blank return_url" do
      PaypalProcessor.request_preapproval(club.price, cancel_url, "", member.name, club.name, Date.today).should == {}
    end

    it "returns a blank hash for a blank member_name" do
      PaypalProcessor.request_preapproval(club.price, cancel_url, return_url, "", club.name, Date.today).should == {}
    end

    it "returns a blank hash for a blank club_name" do
      PaypalProcessor.request_preapproval(club.price, cancel_url, return_url, member.name, "", Date.today).should == {}
    end

    it "returns a blank hash for a blank start_date" do
      PaypalProcessor.request_preapproval(club.price, cancel_url, return_url, member.name, club.name, "").should == {}
    end

    it "returns a blank hash for an invalid response from PayPal" do
      preapproval_key = "PA-5W790039F30657208"

      api = PayPal::SDK::AdaptivePayments::API.new
      PayPal::SDK::AdaptivePayments::API.should_receive(:new).and_return api

      preapproval_request = PayPal::SDK::AdaptivePayments::DataTypes::PreapprovalRequest.new :currencyCode => "BOGUS"
      api.should_receive(:build_preapproval).and_return preapproval_request

      preapproval_error_response = PayPal::SDK::AdaptivePayments::DataTypes::PreapprovalResponse.new :responseEnvelope => {
                                                                                                       :timestamp     => "2013-09-09T16:48:41-07:00",
                                                                                                       :ack           => "Failure",
                                                                                                       :correlationId => "6f5a43f329a85",
                                                                                                       :build         => "6941298"
                                                                                                     },
                                                                                                     :error => [
                                                                                                       {
                                                                                                         :errorId   => 580022,
                                                                                                         :domain    => "PLATFORM",
                                                                                                         :subdomain => "Application",
                                                                                                         :severity  => "Error",
                                                                                                         :category  => "Application",
                                                                                                         :message   => "Blah error failed message",
                                                                                                         :parameter => [
                                                                                                           { :value => "currencyCode" },
                                                                                                           { :value => "null" }
                                                                                                         ]
                                                                                                       }
                                                                                                     ]

      api.should_receive(:preapproval).with(preapproval_request).and_return preapproval_error_response

      PaypalProcessor.request_preapproval(club.price, cancel_url, return_url, member.name, club.name, Date.today).should == {}
    end

    it "returns a hash with a preapproval_key and preapproval_url for a valid request" do
      preapproval_key = "PA-5W790039F30657208"
      start_date      = Date.today

      api = PayPal::SDK::AdaptivePayments::API.new
      PayPal::SDK::AdaptivePayments::API.should_receive(:new).and_return api

      preapproval_request = PayPal::SDK::AdaptivePayments::DataTypes::PreapprovalRequest.new :cancelUrl                    => cancel_url,
                                                                                             :currencyCode                 => "USD",
                                                                                             :maxAmountPerPayment          => club.price,
                                                                                             :maxNumberOfPaymentsPerPeriod => 1,
                                                                                             :paymentPeriod                => "MONTHLY",
                                                                                             :returnUrl                    => return_url,
                                                                                             :requireInstantFundingSource  => true,
                                                                                             :startingDate                 => start_date,
                                                                                             :feesPayer                    => "PRIMARYRECEIVER",
                                                                                             :displayMaxTotalAmount        => true
      api.should_receive(:build_preapproval).and_return preapproval_request

      preapproval_response = PayPal::SDK::AdaptivePayments::DataTypes::PreapprovalResponse.new :responseEnvelope => { :ack => "Success" },
                                                                                               :preapprovalKey => preapproval_key
      api.should_receive(:preapproval).with(preapproval_request).and_return preapproval_response

      preapproval_hash = PaypalProcessor.request_preapproval(club.price, cancel_url, return_url, member.name, club.name, start_date)

      preapproval_hash[:preapproval_key].should == preapproval_key
      preapproval_hash[:preapproval_url].should == "https://www.sandbox.paypal.com/webscr?cmd=_ap-preapproval&preapprovalkey=#{preapproval_key}"
    end
  end

  describe ".bill_user(amount, payment_email, preapproval_key)" do
    let!(:club)              { FactoryGirl.create :club }
    let!(:member)            { FactoryGirl.create :user }
    let!(:club_owner_amount) { 6.0 }
    let!(:ifsimply_amount)   { 4.0 }
    let!(:payment_email)     { Faker::Internet.email }
    let!(:preapproval_key)   { Faker::Lorem.words(2).join "," }

    it "returns a blank hash for a blank club_owner_amount" do
      PaypalProcessor.bill_user("", ifsimply_amount, payment_email, preapproval_key).should == {}
    end

    it "returns a blank hash for a blank ifsimply_amount" do
      PaypalProcessor.bill_user(club_owner_amount, "", payment_email, preapproval_key).should == {}
    end

    it "returns a blank hash for a blank payment_email" do
      PaypalProcessor.bill_user(club_owner_amount, ifsimply_amount, "", preapproval_key).should == {}
    end

    it "returns a blank hash for a blank preapproval_key" do
      PaypalProcessor.bill_user(club_owner_amount, ifsimply_amount, payment_email, "").should == {}
    end


    it "returns a hash with false success and an error message for an invalid response from PayPal" do
      preapproval_key = "PA-5W790039F30657208"
      error_message   = "Blah error failed message"

      api = PayPal::SDK::AdaptivePayments::API.new
      PayPal::SDK::AdaptivePayments::API.should_receive(:new).and_return api

      pay_request = PayPal::SDK::AdaptivePayments::DataTypes::PayRequest.new
      api.should_receive(:build_pay).and_return pay_request

      pay_error_response = PayPal::SDK::AdaptivePayments::DataTypes::PayResponse.new :responseEnvelope => {
                                                                                       :timestamp     => "2013-09-09T16:48:41-07:00",
                                                                                       :ack           => "Failure",
                                                                                       :correlationId => "6f5a43f329a85",
                                                                                       :build         => "6941298"
                                                                                     },
                                                                                     :error => [
                                                                                       {
                                                                                         :errorId   => 580022,
                                                                                         :domain    => "PLATFORM",
                                                                                         :subdomain => "Application",
                                                                                         :severity  => "Error",
                                                                                         :category  => "Application",
                                                                                         :message   => error_message
                                                                                       }
                                                                                     ]

      api.should_receive(:pay).with(pay_request).and_return pay_error_response

      PaypalProcessor.bill_user(club_owner_amount, ifsimply_amount, payment_email, preapproval_key).should == { :success => false, :pay_key => "", :error => error_message }
    end

    describe "for a valid request" do
      let(:pay_key) { "AP-7L748474VE7451234" }

      before :each do
        preapproval_key = "PA-5W790039F30657208"

        api = PayPal::SDK::AdaptivePayments::API.new
        PayPal::SDK::AdaptivePayments::API.should_receive(:new).and_return api

        pay_request = PayPal::SDK::AdaptivePayments::DataTypes::PayRequest.new
        api.should_receive(:build_pay).and_return pay_request

        pay_success_response = PayPal::SDK::AdaptivePayments::DataTypes::PayResponse.new :responseEnvelope => {
                                                                                           :timestamp     => "2013-09-09T16:48:41-07:00",
                                                                                           :ack           => "Success",
                                                                                           :correlationId => "6f5a43f329a85",
                                                                                           :build         => "6941298"
                                                                                         },
                                                                                         :payKey => pay_key,
                                                                                         :error => [ ]

        api.should_receive(:pay).with(pay_request).and_return pay_success_response
      end

      it "returns a hash with a blank error value for a valid request" do
        PaypalProcessor.bill_user(club_owner_amount, ifsimply_amount, payment_email, preapproval_key).should == { :success => true, :pay_key => pay_key, :error => "" }
      end

      it "returns a hash with a pay_key value" do
        PaypalProcessor.bill_user(club_owner_amount, ifsimply_amount, payment_email, preapproval_key).should == { :success => true, :pay_key => pay_key, :error => "" }
      end
    end
  end
end
