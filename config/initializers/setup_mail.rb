ActionMailer::Base.smtp_settings = {
  :address              => Settings.email[:address],
  :port                 => Settings.email[:port],
  :domain               => Settings.email[:domain],
  :user_name            => Settings.email[:user_name],
  :password             => Settings.email[:password],
  :authentication       => Settings.email[:authentication],
  :enable_starttls_auto => Settings.email[:enable_starttls_auto]
}

ActionMailer::Base.default_url_options = {
  :host => "#{Settings.general[:host]}:#{Settings.general[:port]}"
}

if Rails.env.development? or Rails.env.test?
  puts "Setting up development mail interceptor..."
  Mail.register_interceptor(DevelopmentMailInterceptor)
  puts "Development mail interceptor set up."
end
