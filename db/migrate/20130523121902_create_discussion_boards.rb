class CreateDiscussionBoards < ActiveRecord::Migration
  def change
    create_table :discussion_boards do |t|
      t.string :name
      t.string :description

      t.string :slug

      t.references :club

      t.timestamps
    end

    add_index :discussion_boards, :club_id
    add_index :discussion_boards, :slug, :unique => true
  end
end
