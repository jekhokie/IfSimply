class ChangeUserIconToString < ActiveRecord::Migration
  def up
    remove_attachment :users, :icon
    add_column :users, :icon, :string

    User.all.each{|u| u.update_attributes :icon => "/assets/iS_club_thumb.jpg"}
  end

  def down
    remove_column :users, :icon
    add_attachment :users, :icon
  end
end
