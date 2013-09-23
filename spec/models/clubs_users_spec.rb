require 'spec_helper'

describe ClubsUsers do
  it { should belong_to :club }
  it { should belong_to :user }

  it { should ensure_inclusion_of(:level).in_array      [ "basic", "pro" ] }
  it { should ensure_inclusion_of(:pro_status).in_array [ "ACTIVE", "INACTIVE", "FAILED_PAYMENT" ] }

  it "can be instantiated" do
    ClubsUsers.new.should be_an_instance_of(ClubsUsers)
  end

  it "assigns pro_status as INACTIVE on initial create" do
    ClubsUsers.new.pro_status.should == "INACTIVE"
  end

  describe ".paying scope" do
    let!(:pro_active_subscription)   { FactoryGirl.create :subscription, :level => 'pro', :pro_status => "ACTIVE" }
    let!(:pro_inactive_subscription) { FactoryGirl.create :subscription, :level => 'pro', :pro_status => "INACTIVE" }
    let!(:pro_failed_subscription)   { FactoryGirl.create :subscription, :level => 'pro', :pro_status => "FAILED_PAYMENT" }
    let!(:basic_subscription)        { FactoryGirl.create :subscription, :level => 'basic' }

    it "returns pro subscriptions that are pro_status ACTIVE" do
      ClubsUsers.paying.should include(pro_active_subscription)
    end

    it "does not return pro subscriptions that are pro_status INACTIVE" do
      ClubsUsers.paying.should_not include(basic_subscription)
    end

    it "does not return pro subscriptions that are pro_status FAILED_PAYMENT" do
      ClubsUsers.paying.should_not include(pro_failed_subscription)
    end

    it "does not return basic subscriptions" do
      ClubsUsers.paying.should_not include(pro_inactive_subscription)
    end
  end
end
