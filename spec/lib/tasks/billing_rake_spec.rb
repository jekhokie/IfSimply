require 'spec_helper'
require 'rake'

describe "billing" do
  before :each do
    Rake.application.rake_require 'tasks/billing'
    Rake::Task.define_task :environment
  end

  describe "bill_users" do
    let!(:task_name) { "billing:bill_users" }

    it "requires 'environment' as a prereq" do
      Rake::Task[task_name].prerequisites.should include("environment")
    end

    describe "for active pro subscriptions" do
      let!(:pro_active_subscription) { FactoryGirl.create :subscription, :level => 'pro', :pro_status => "ACTIVE" }

      it "bills the users" do
        ClubsUsers.should_receive(:find).with(pro_active_subscription.id).and_return pro_active_subscription
        pro_active_subscription.should_receive(:preapproval_key)
        Rake::Task[task_name].invoke
      end
    end

    describe "for inactive pro subscriptions" do
      let!(:pro_inactive_subscription) { FactoryGirl.create :subscription, :level => 'pro', :pro_status => "INACTIVE" }

      it "does not bill the users" do
        ClubsUsers.should_not_receive(:find)
        Rake::Task[task_name].invoke
      end
    end

    describe "for basic subscriptions" do
      let!(:basic_subscription) { FactoryGirl.create :subscription, :level => 'basic' }

      it "does not bill the users" do
        ClubsUsers.should_not_receive(:find)
        Rake::Task[task_name].invoke
      end
    end
  end
end
