set :output, "log/whenever.log"

# Perform billing operations every day at 1AM
# every 1.day, :at => '1:00am' do
# The below content is for testing/debugging purposes only
every 1.minute do
  rake "billing:bill_users"
end
