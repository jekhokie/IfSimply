class AddSlugToDiscussionBoards < ActiveRecord::Migration
  def change
    add_column :discussion_boards, :slug, :string
    add_index :discussion_boards, :slug, :unique => true
  end
end
