set :output, "log/whenever.log"

# perform billing operations every day at 1AM
every 1.day, :at => '1:00am' do
  rake "billing:bill_users"
end
