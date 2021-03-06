source 'https://rubygems.org'

gem 'activeadmin'
gem 'best_in_place', :git => 'http://github.com/jekhokie/best_in_place.git'
gem 'cancan'
gem 'daemons'
gem 'delayed_job', '~> 3.0'
gem 'delayed_job_active_record', :git => 'http://github.com/gaslight/delayed_job_active_record'
gem 'devise'
gem 'devise-async'
gem 'google-webfonts', :git => 'http://github.com/jekhokie/Google-Webfonts-Helper.git'
gem 'jquery-rails', '~> 2.3.0'
gem 'jquery-ui-rails'
gem 'mercury-rails', :git => 'http://github.com/jekhokie/mercury.git'
gem 'money-rails'
gem 'rails', '3.2.13'
gem 'rails_autolink'
gem 'rails_config'
gem 'remotipart'
gem 'redcarpet'

# MailChimp support
gem 'gibbon'

# safe html truncating
gem 'truncate_html'

# web services
gem 'passenger'

# profiling
gem 'newrelic_rpm'
gem 'google-analytics-rails'

# custom video player
gem 'videojs_rails'

# ordering courses
gem 'acts_as_list'

# scheduling for billing, etc.
gem 'whenever'

# friendly URLs
gem 'friendly_id'

# paypal capabilities
gem 'paypal-sdk-adaptiveaccounts'
gem 'paypal-sdk-adaptivepayments'

# handling of uploads
gem 'paperclip'

# required to be outside assets
gem 'coffee-rails', '~> 3.2.1'
gem 'simple_form'

group :assets do
  gem 'less-rails'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'therubyracer', :platforms => :ruby
  gem 'twitter-bootstrap-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'simplecov', :require => false
end

group :development do
  gem 'debugger'
end

group :test, :development do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner', '<= 1.0.1'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'fakeweb'
  gem 'launchy'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
