require 'spec_helper'
require 'rake'

describe "billing" do
  before :each do
    @rake = Rake::Application.new
    Rake.application = @rake
    load Rails.root + 'lib/tasks/billing.rake'
    Rake::Task.define_task :environment
  end

  describe "bill_users" do
    before do
      @task_name = "billing:bill_users"
    end

    it "requires 'environment' as a prereq" do
      @rake[@task_name].prerequisites.should include("environment")
    end

    describe "for active pro subscriptions" do
      describe "with a preapproval key" do
        let!(:pro_active_subscription) { FactoryGirl.create :subscription, :level => 'pro', :preapproval_key => "LAGIHEIGLHI", :pro_status => "ACTIVE" }

        it "bills the users" do
          ClubsUsers.should_receive(:find).with(pro_active_subscription.id).and_return pro_active_subscription
          pro_active_subscription.should_receive(:preapproval_key)
          @rake[@task_name].invoke
        end
      end

      describe "with no preapproval key" do
        let!(:pro_active_subscription) { FactoryGirl.create :subscription, :level => 'pro', :preapproval_key => "", :pro_status => "ACTIVE" }

        it "changes the pro_status to 'FAILED_PREAPPROVAL'" do
          @rake[@task_name].invoke

          pro_active_subscription.reload
          pro_active_subscription.pro_status.should == "FAILED_PREAPPROVAL"
        end
      end
    end

    describe "for inactive pro subscriptions" do
      let!(:pro_inactive_subscription) { FactoryGirl.create :subscription, :level => 'pro', :pro_status => "INACTIVE" }

      it "does not bill the users" do
        ClubsUsers.should_not_receive(:find)
        @rake[@task_name].invoke
      end
    end

    describe "for basic subscriptions" do
      let!(:basic_subscription) { FactoryGirl.create :subscription, :level => 'basic' }

      it "does not bill the users" do
        ClubsUsers.should_not_receive(:find)
        @rake[@task_name].invoke
      end
    end
  end
end
