class AddErrorToClubsUsers < ActiveRecord::Migration
  def change
    add_column :clubs_users, :error, :string
  end
end
