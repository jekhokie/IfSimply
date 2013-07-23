class AddUserIdToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :user_id, :integer
    add_index  :topics, :user_id

    Topic.all.each do |topic|
      topic.user_id = topic.discussion_board.user.id
      topic.save
    end
  end
end
