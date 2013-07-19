class CreateClubsUsers < ActiveRecord::Migration
  def change
    create_table :clubs_users do |t|
      t.string :level

      t.references :user, :null => false
      t.references :club, :null => false

      t.timestamps
    end

    add_index :clubs_users, :club_id
    add_index :clubs_users, :user_id
  end
end
