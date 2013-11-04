class PaymentMailer < ActionMailer::Base
  default :from => "admin@ifsimply.com"

  def failed_payment_notification(email, name, club_name, error)
    @name      = name
    @club_name = club_name
    @error     = error

    mail :to => email, :subject => "IfSimply Failed Payment"
  end
end
