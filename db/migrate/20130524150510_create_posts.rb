class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.text :content, :limit => nil

      t.references :topic

      t.timestamps
    end

    add_index :posts, :user_id
    add_index :posts, :topic_id
  end
end
