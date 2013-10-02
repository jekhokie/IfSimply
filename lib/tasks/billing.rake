namespace :billing do
  desc 'Task to bill all paying members'
  task :bill_users => :environment do
    ClubsUsers.paying.try(:map, &:id).try(:each) do |subscription_id|
      subscription = ClubsUsers.find subscription_id

      # need to double-check that the subscription is still valid for billing
      # since the last query since it may have changed in the time lapse
      if subscription.level == 'pro' and subscription.pro_status == "ACTIVE"
        preapproval_key = subscription.preapproval_key

        if preapproval_key.nil? or preapproval_key.empty?
          subscription.pro_status = "FAILED_PREAPPROVAL"
          subscription.save
        else
          # if the date is within range for billing:
          #   if billing the user succeeds:
          #     - create billing entry in the billings table
          #   else:
          #     - set the pro_status to "FAILED_PAYMENT"
          # else:
          #   - ignore/pass over
        end
      end
    end
  end
end
