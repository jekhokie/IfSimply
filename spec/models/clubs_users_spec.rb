require 'spec_helper'

describe ClubsUsers do
  it { should belong_to :club }
  it { should belong_to :user }

  it { should ensure_inclusion_of(:level).in_array      [ "basic", "pro" ] }
  it { should ensure_inclusion_of(:pro_status).in_array [ "ACTIVE", "INACTIVE", "FAILED_PAYMENT", "FAILED_PREAPPROVAL", "PRO_CHANGE" ] }

  it "can be instantiated" do
    ClubsUsers.new.should be_an_instance_of(ClubsUsers)
  end

  it "assigns pro_status as INACTIVE on initial create" do
    ClubsUsers.new.pro_status.should == "INACTIVE"
  end

  it "assigns was_pro as false on initial create" do
    ClubsUsers.new.was_pro.should == false
  end

  describe ".paying scope" do
    let!(:pro_active_subscription)     { FactoryGirl.create :subscription, :level => 'pro', :pro_status => "ACTIVE" }
    let!(:pro_inactive_subscription)   { FactoryGirl.create :subscription, :level => 'pro', :pro_status => "INACTIVE" }
    let!(:pro_failed_subscription)     { FactoryGirl.create :subscription, :level => 'pro', :pro_status => "FAILED_PAYMENT" }
    let!(:pro_failed_pre_subscription) { FactoryGirl.create :subscription, :level => 'pro', :pro_status => "FAILED_PREAPPROVAL" }
    let!(:basic_subscription)          { FactoryGirl.create :subscription, :level => 'basic' }

    it "returns pro subscriptions that are pro_status ACTIVE" do
      ClubsUsers.paying.should include(pro_active_subscription)
    end

    it "does not return pro subscriptions that are pro_status INACTIVE" do
      ClubsUsers.paying.should_not include(basic_subscription)
    end

    it "does not return pro subscriptions that are pro_status FAILED_PAYMENT" do
      ClubsUsers.paying.should_not include(pro_failed_subscription)
    end

    it "does not return pro subscriptions that are pro_status FAILED_PREAPPROVAL" do
      ClubsUsers.paying.should_not include(pro_failed_pre_subscription)
    end

    it "does not return basic subscriptions" do
      ClubsUsers.paying.should_not include(pro_inactive_subscription)
    end
  end

  describe "pro within_trial_period?" do
    let!(:pro_inside_trial_period)  { FactoryGirl.create :subscription, :level => 'pro', :anniversary_date => Date.today + 2.days }
    let!(:pro_on_anniversary_date)  { FactoryGirl.create :subscription, :level => 'pro', :anniversary_date => Date.today }
    let!(:pro_outside_trial_period) { FactoryGirl.create :subscription, :level => 'pro', :anniversary_date => Date.today - 2.days }

    it "returns true for a subscription still within the trial period" do
      pro_inside_trial_period.within_trial_period?.should == true
    end

    it "returns false for a subscription on the anniversary date" do
      pro_on_anniversary_date.within_trial_period?.should == false
    end

    it "returns false for a subscription outside the trial period" do
      pro_outside_trial_period.within_trial_period?.should == false
    end
  end
end
