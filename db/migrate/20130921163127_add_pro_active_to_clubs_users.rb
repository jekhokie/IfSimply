class AddProActiveToClubsUsers < ActiveRecord::Migration
  def change
    add_column :clubs_users, :pro_active, :boolean, :default => false
  end
end
