class AddLogoDescriptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :description, :text
    add_attachment :users, :icon

    User.all.each do |user|
      user.update_attributes :description => Settings.users[:default_description]
    end
  end
end
