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
        let(:pro_active_subscription) { FactoryGirl.create :subscription, :level => 'pro', :preapproval_key => "LAGIHEIGLHI", :pro_status => "ACTIVE", :anniversary_date => Date.today }

        it "bills the users" do
          ClubsUsers.should_receive(:find).with(pro_active_subscription.id).and_return pro_active_subscription
          PaypalProcessor.should_receive(:bill_user).and_return({ :success => true })
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

      describe "when the subscribers' anniversary date is the last day of a month that has less days and the current date is the last day" do
        let(:billable_subscription) { FactoryGirl.create :subscription, :level => 'pro', :preapproval_key => "LAGIHEIGLHI", :pro_status => "ACTIVE", :anniversary_date => Date.new(2013, 01, 31) }

        it "attempts to bill the user" do
          Date.should_receive(:today).and_return Date.new(2013, 02, 28)
          ClubsUsers.should_receive(:find).with(billable_subscription.id).and_return billable_subscription
          PaypalProcessor.should_receive(:bill_user).and_return({ :success => true, :pay_key => "AP-1398fg02h83t028" })
          @rake[@task_name].invoke
        end
      end

      describe "when the current day is a day that lines up with the subscribers' anniversary" do
        let(:billable_subscription) { FactoryGirl.create :subscription, :level => 'pro', :preapproval_key => "LAGIHEIGLHI", :pro_status => "ACTIVE", :anniversary_date => Date.today }

        it "attempts to bill the user" do
          ClubsUsers.should_receive(:find).with(billable_subscription.id).and_return billable_subscription
          PaypalProcessor.should_receive(:bill_user).and_return({ :success => true, :pay_key => "AP-1398fg02h83t028" })
          @rake[@task_name].invoke
        end
      end

      describe "for a day that does not line up with the subscribers' anniversary" do
        let!(:subscription) { FactoryGirl.create :subscription, :level => 'pro', :preapproval_key => "LAGIHEIGLHI", :pro_status => "ACTIVE", :anniversary_date => Date.today - 1.day }

        describe "when there is an existing payment for that month" do
          let!(:payment) { FactoryGirl.create :payment, :payer_email => subscription.user.email }

          it "does not attempt to bill the user" do
            ClubsUsers.should_receive(:find).with(subscription.id).and_return subscription
            PaypalProcessor.should_not_receive(:bill_user)
            @rake[@task_name].invoke
          end
        end

        describe "when there is no existing payment for that month" do
          it "bills the user" do
            ClubsUsers.should_receive(:find).with(subscription.id).and_return subscription
            PaypalProcessor.should_receive(:bill_user).and_return({ :success => true, :pay_key => "AP-1398fg02h83t028" })
            @rake[@task_name].invoke
          end
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
