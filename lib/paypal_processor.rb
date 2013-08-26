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
end
