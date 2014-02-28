require 'devise'

module PaypalProcessor
  def self.is_verified?(first_name, last_name, paypal_email)
    return false unless first_name
    return false unless last_name
    return false unless paypal_email =~ /#{Devise::email_regexp}/

    @api = PayPal::SDK::AdaptiveAccounts::API.new

    @get_verified_status = @api.build_get_verified_status({ :emailAddress  => paypal_email,
                                                            :matchCriteria => "NAME",
                                                            :firstName     => first_name,
                                                            :lastName      => last_name })

    # Make API call & get response
    @account_info = @api.get_verified_status(@get_verified_status)

    # Access Response
    if @account_info.success?
      return @account_info.accountStatus == PayPal::SDK::Core::API::IPN::VERIFIED
    else
      return false
    end
  end

  def self.request_preapproval(monthly_amount, total_amount, cancel_url, return_url, member_name, club_name, start_date, end_date)
    return {} if monthly_amount.blank?
    return {} if total_amount.blank?
    return {} if cancel_url.blank?
    return {} if return_url.blank?
    return {} if member_name.blank?
    return {} if club_name.blank?
    return {} if start_date.blank?
    return {} if end_date.blank?

    @api = PayPal::SDK::AdaptivePayments::API.new

    # Build request object
    @preapproval = @api.build_preapproval({
      :clientDetails => {
        :applicationId => Settings.general[:default_application_name],
        :customerId    => member_name,
        :customerType  => "Member",
        :partnerName   => Settings.general[:default_partner_name]
      },
      :memo                         => "Membership To: #{club_name}",
      :cancelUrl                    => cancel_url,
      :currencyCode                 => "USD",
      :endingDate                   => end_date,
      :maxAmountPerPayment          => monthly_amount,
      :maxNumberOfPaymentsPerPeriod => 1,
      :maxTotalAmountOfAllPayments  => total_amount,
      :paymentPeriod                => "MONTHLY",
      :returnUrl                    => return_url,
      :requireInstantFundingSource  => true,
      :startingDate                 => start_date,
      :feesPayer                    => "PRIMARYRECEIVER",
      :displayMaxTotalAmount        => true })

    # Make API call & get response
    @preapproval_response = @api.preapproval(@preapproval)

    # Access Response
    if @preapproval_response.success?
      { :preapproval_key => @preapproval_response.preapproval_key, :preapproval_url => @api.preapproval_url(@preapproval_response) }
    else
      { }
    end
  end

  def self.bill_user(primary_amount, ifsimply_amount, payment_email, preapproval_key)
    return {} if primary_amount.blank?
    return {} if ifsimply_amount.blank?
    return {} if payment_email.blank?
    return {} if preapproval_key.blank?

    @api = PayPal::SDK::AdaptivePayments::API.new

    @payment = @api.build_pay({
      :actionType         => "PAY",
      :currencyCode       => "USD",
      :feesPayer          => "SECONDARYONLY",
      :cancelUrl          => "http://www.ifsimply.com/",
      :returnUrl          => "http://www.ifsimply.com/",
      :ipnNotificationUrl => "http://www.ifsimply.com/",
      :receiverList => {
        :receiver => [
          {
            :primary     => true,
            :email       => payment_email,
            :amount      => primary_amount,
            :paymentType => "DIGITALGOODS"
          },
          {
            :primary     => false,
            :email       => Settings.paypal[:account_email],
            :amount      => ifsimply_amount,
            :paymentType => "DIGITALGOODS"
          }
        ]
      },
      :requestEnvelope => { :errorLanguage => "en_US" },
      :reverseAllParallelPaymentsOnError => true,
      :preapprovalKey => preapproval_key
    })

    # Make API call & get response
    @pay_response = @api.pay(@payment)

    # Access Response
    if @pay_response.success?
      { :success => true, :pay_key => @pay_response.payKey, :error => "" }
    else
      { :success => false, :pay_key => "", :error => @pay_response.error.first.message }
    end
  end
end
