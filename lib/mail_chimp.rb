module MailChimp
  def self.add_to_list(api_key, list_id, name, email)
    begin
      gb = Gibbon::API.new(api_key)
      gb.lists.subscribe({ :id         => Settings.mailchimp[:ifsimply_list_id],
                           :email      => { :email        => email },
                           :merge_vars => { :FNAME        => name },
                                            :double_optin => false })
    rescue Exception => e
      puts "ERROR: Could not add user with email #{email} to list ID #{list_id}: #{e.message}"
      return false
    end

    return true
  end
end
