namespace :user do
  task :resend_confirmation => :environment do
    users = User.where('confirmation_token IS NOT NULL')
      users.each do |user|
      user.send_confirmation_instructions
    end
  end
end
