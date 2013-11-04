class ChangeClubsUsersProActiveToProStatus < ActiveRecord::Migration
  def up
    rename_column :clubs_users, :pro_active, :pro_status
    change_column :clubs_users, :pro_status, :string, :default => "INACTIVE"

    ClubsUsers.all.each do |subscription|
      subscription.pro_status == "t" ? subscription.pro_status = "ACTIVE" : subscription.pro_status = "INACTIVE"
      subscription.save
    end
  end

  def down
    ClubsUsers.all.each do |subscription|
      subscription.pro_status == "ACTIVE" ? subscription.pro_status = "t" : subscription.pro_status = "f"
      subscription.save
    end

    change_column :clubs_users, :pro_status, :boolean
    rename_column :clubs_users, :pro_status, :pro_active
  end
end
