class AddPreapprovalKeyToClubsUsers < ActiveRecord::Migration
  def change
    add_column :clubs_users, :preapproval_key, :string
  end
end
