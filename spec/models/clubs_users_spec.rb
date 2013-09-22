require 'spec_helper'

describe ClubsUsers do
  it { should belong_to :club }
  it { should belong_to :user }

  it { should ensure_inclusion_of(:level).in_array [ "basic", "pro" ] }

  it "can be instantiated" do
    ClubsUsers.new.should be_an_instance_of(ClubsUsers)
  end

  it "assigns pro_active as false on initial create" do
    ClubsUsers.new.pro_active.should == false
  end

  describe ".paying scope" do
    let!(:pro_active_subscription)   { FactoryGirl.create :subscription, :level => 'pro', :pro_active => true }
    let!(:pro_inactive_subscription) { FactoryGirl.create :subscription, :level => 'pro', :pro_active => false }
    let!(:basic_subscription)        { FactoryGirl.create :subscription, :level => 'basic' }

    it "returns pro subscriptions that are pro_active" do
      ClubsUsers.paying.should include(pro_active_subscription)
    end

    it "does not return basic subscriptions" do
      ClubsUsers.paying.should_not include(pro_inactive_subscription)
    end

    it "does not return pro subscriptions that are not pro_active" do
      ClubsUsers.paying.should_not include(basic_subscription)
    end
  end
end
