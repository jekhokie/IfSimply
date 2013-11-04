require 'spec_helper'

describe Payment do
  describe "valid?" do
    # payer_email
    it "returns false when no payer_email is specified" do
      FactoryGirl.build(:payment, :payer_email => "").should_not be_valid
    end

    # payee_email
    it "returns false when no payee_email is specified" do
      FactoryGirl.build(:payment, :payee_email => "").should_not be_valid
    end

    # pay_key
    it "returns false when no pay_key is specified" do
      FactoryGirl.build(:payment, :pay_key => "").should_not be_valid
    end

    # amount
    it "returns false when no total_amount is specified" do
      FactoryGirl.build(:payment, :total_amount_cents => "").should_not be_valid
    end

    # payee_share
    it "returns false when no payee_share is specified" do
      FactoryGirl.build(:payment, :payee_share => "").should_not be_valid
    end

    # house_share
    it "returns false when no house_share is specified" do
      FactoryGirl.build(:payment, :house_share => "").should_not be_valid
    end
  end
end
