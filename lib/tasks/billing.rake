namespace :billing do
  desc 'Task to bill all paying members'
  task :bill_users => :environment do
    puts "#{Time.now} -- [INFO] -- Starting billing..."
    ClubsUsers.paying.try(:map, &:id).try(:each) do |subscription_id|
      subscription = ClubsUsers.find subscription_id

      puts "#{Time.now} -- [INFO] -- Assessing subscription with ID: #{subscription.id}"

      # need to double-check that the subscription is still valid for billing
      # since the last query since it may have changed in the time lapse
      if subscription.level == 'pro' and subscription.pro_status == "ACTIVE"
        preapproval_key = subscription.preapproval_key

        if preapproval_key.nil? or preapproval_key.empty?
          subscription.pro_status = "FAILED_PREAPPROVAL"
          subscription.save
          puts "#{Time.now} -- [ERROR] -- Failed preapproval; no preapproval key for subscription with ID: #{subscription.id}"
        else
          today_date       = Date.today
          anniversary_date = subscription.anniversary_date
          days_in_month    = Time.days_in_month(today_date.month, today_date.year)
          last_payment     = Payment.where(:payer_email => subscription.user.email).sort_by(&:created_at).last.try(:created_at)

          puts "#{Time.now} -- [INFO] -- Last Payment: #{last_payment.inspect}"

          # bill the user:
          # IF
          # - we hit an anniversary day
          # OR
          # - today is the last day of the month and the anniversary day is greater than today's day (30 days vs 28 days, etc.)
          # OR
          # - today is greater than the anniversary day and there is no payment for this month
          if today_date.day  == anniversary_date.day    or
             (today_date     == today_date.end_of_month and today_date.end_of_month.day <  anniversary_date.day) or
             (today_date.day >  anniversary_date.day    and (!last_payment or last_payment.month != today_date.month))
            # make sure a user is not double-billed in the same month
            if last_payment.nil? or last_payment.month != today_date.month
              # determine shares for each user and information about each
              club_cost         = subscription.club.price.to_f
              club_owner_amount = ("%.2f" % (club_cost * Settings.paypal[:club_owner_share])).to_f
              ifsimply_amount   = ("%.2f" % (club_cost * Settings.paypal[:ifsimply_share])).to_f
              payee_email       = subscription.club.user.payment_email

              # bill the user, and check for success
              pay_response = PaypalProcessor.bill_user(club_owner_amount, ifsimply_amount, payee_email, preapproval_key)

              if pay_response[:success] == true
                payment = Payment.create :payer_email  => "#{subscription.user.email}",
                                         :payee_email  => "#{payee_email}",
                                         :pay_key      => "#{pay_response[:pay_key]}",
                                         :total_amount => "#{club_cost}",
                                         :payee_share  => "#{club_owner_amount}",
                                         :house_share  => "#{ifsimply_amount}"

                subscription.error = nil
                subscription.save

                puts "#{Time.now} -- [PROFIT] -- Succeeded billing: subscription - #{subscription.id} | payment - #{payment.id}"
                puts "#{Time.now} -- [MONEY] -- Club Owner: #{club_owner_amount} | IfSimply: #{ifsimply_amount}"
              else
                subscription.pro_status = "FAILED_PAYMENT"
                subscription.error      = pay_response[:error]
                subscription.save

                puts "#{Time.now} -- [ERROR] -- Failed attempted payment for subscription with ID: #{subscription.id}"

                PaymentMailer.delay.failed_payment_notification(subscription.user.email,
                                                                subscription.user.name,
                                                                "#{subscription.club.name} #{subscription.club.sub_heading}",
                                                                pay_response[:error])
              end
            end
          end
        end
      end
    end

    puts "#{Time.now} -- Billing complete."
  end
end
