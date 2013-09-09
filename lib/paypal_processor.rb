require 'devise'

module PaypalProcessor
  def self.is_verified?(paypal_email)
    return false unless paypal_email =~ /#{Devise::email_regexp}/

    @api = PayPal::SDK::AdaptiveAccounts::API.new

    @get_verified_status = @api.build_get_verified_status({ :emailAddress => paypal_email, :matchCriteria => "NONE" })

    # Make API call & get response
    @account_info = @api.get_verified_status(@get_verified_status)

    # Access Response
    if @account_info.success?
      return @account_info.accountStatus == PayPal::SDK::Core::API::IPN::VERIFIED
    else
      return false
    end
  end

  def self.request_preapproval_url(monthly_amount, cancel_url, return_url, ipn_url, member_name, club_name)
    return "" if monthly_amount.blank?
    return "" if cancel_url.blank?
    return "" if return_url.blank?
    return "" if ipn_url.blank?
    return "" if member_name.blank?
    return "" if club_name.blank?

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
      :maxAmountPerPayment          => monthly_amount,
      :maxNumberOfPaymentsPerPeriod => 1,
      :paymentPeriod                => "MONTHLY",
      :returnUrl                    => return_url,
      :requireInstantFundingSource  => true,
      :ipnNotificationUrl           => ipn_url,
      :startingDate                 => DateTime.now,
      :feesPayer                    => "PRIMARYRECEIVER",
      :displayMaxTotalAmount        => true })

    # Make API call & get response
    @preapproval_response = @api.preapproval(@preapproval)

    # Access Response
    if @preapproval_response.success?
      @api.preapproval_url(@preapproval_response) # Url to complete payment
    else
      ""
    end
  end
end
