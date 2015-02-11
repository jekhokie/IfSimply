class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :subject
      t.text :description, :limit => nil

      t.string :slug

      t.references :discussion_board

      t.timestamps
    end

    add_index :topics, :discussion_board_id
    add_index :topics, :slug, :unique => true
  end
end
