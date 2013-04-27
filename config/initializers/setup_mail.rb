ActionMailer::Base.smtp_settings = {
  :address              => Settings.email[:address],
  :port                 => Settings.email[:port],
  :domain               => Settings.email[:domain],
  :user_name            => Settings.email[:user_name],
  :password             => Settings.email[:password],
  :authentication       => Settings.email[:authentication],
  :enable_starttls_auto => Settings.email[:enable_starttls_auto]
}

Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development? or Rails.env.test?
