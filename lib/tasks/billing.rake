namespace :billing do
  desc 'Task to bill all paying members'
  task :bill_users => :environment do
    ClubsUsers.paying.try(:map, &:id).try(:each) do |subscription_id|
      subscription = ClubsUsers.find subscription_id

      # need to double-check that the subscription is still valid for billing
      # since the last query since it may have changed in the time lapse
      if subscription.level == 'pro' and subscription.pro_active == true
        if (preapproval_key = subscription.preapproval_key).blank?
        else
        end

        # TODO: - if there is a preapproval key:
        # TODO:   - if the date is within range for billing:
        # TODO:     - if billing the user succeeds:
        # TODO:       - create billing entry in billings table
        # TODO:     - if billing the user fails:
        # TODO:       - set the pro_status to 'failed_payment'
        # TODO:   - if the date is not within range for billing:
        # TODO:     - ignore/pass over (next)
        # TODO: - if there is no preapproval key:
        # TODO:   - set the pro_active to false
      end
    end
  end
end
