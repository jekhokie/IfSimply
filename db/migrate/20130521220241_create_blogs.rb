class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.string :content
      t.attachment :image

      t.references :club

      t.timestamps
    end

    add_index :blogs, :club_id
  end
end
