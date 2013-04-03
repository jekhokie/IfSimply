class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :description
      t.string :logo

      t.money :price

      t.references :user

      t.timestamps
    end
  end
end
