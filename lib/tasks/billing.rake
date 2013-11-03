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
          today_date       = Date.today
          anniversary_date = subscription.anniversary_date
          days_in_month    = Time.days_in_month(today_date.month, today_date.year)

          # bill the user:
          # IF
          # - we hit an anniversary day
          # OR
          # - today is the last day of the month and the anniversary day is greater than today's day (30 days vs 28 days, etc.)
          if today_date.day == anniversary_date.day or
             (today_date == today_date.end_of_month and today_date.end_of_month.day < anniversary_date.day)

            # determine shares for each user
            club_cost = subscription.club.price.to_f
            club_owner_amount = ("%.2f" % (club_cost * Settings.paypal[:club_owner_share])).to_f
            ifsimply_amount   = ("%.2f" % (club_cost * Settings.paypal[:ifsimply_share])).to_f

            # bill the user, and check for success
            pay_response = PaypalProcessor.bill_user(club_owner_amount, ifsimply_amount, subscription.club.user.payment_email, preapproval_key)

            if pay_response[:success] == true
              # create the billing entry in the transactions table with the pay_response[:pay_key] value, subscriber_id, and club_id
            else
              # set the pro_status to FAILED_PAYMENT for the subscription
              # email the user that they have a failed payment and access to subscription.club.name is restricted
              # create the billing entry in the transactions table with subscriber_id, club_id and pay_response[:error] value
            end
          end
        end
      end
    end
  end
end
