class AccountMailer < ActionMailer::Base
  default :from => "admin@ifsimply.com"

  def sign_up_thank_you(user, request_protocol, request_host)
    @user             = user
    @request_protocol = request_protocol
    @request_host     = request_host

    mail :to => @user.email, :subject => "Thanks for Signing Up!"
  end
end
