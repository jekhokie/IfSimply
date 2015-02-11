class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :description
      t.string :logo

      t.money :price

      t.string :slug

      t.references :user

      t.timestamps
    end

    add_index :clubs, :user_id
    add_index :clubs, :slug, :unique => true
  end
end
