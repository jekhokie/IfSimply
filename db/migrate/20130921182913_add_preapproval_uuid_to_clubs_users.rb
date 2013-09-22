class AddPreapprovalUuidToClubsUsers < ActiveRecord::Migration
  def change
    add_column :clubs_users, :preapproval_uuid, :string
  end
end
