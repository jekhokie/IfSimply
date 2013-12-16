class AddWasProToClubsUsers < ActiveRecord::Migration
  def change
    add_column :clubs_users, :was_pro, :boolean, :default => false

    ClubsUsers.all.each do |subscription|
      subscription.was_pro = false
      subscription.save
    end
  end
end
